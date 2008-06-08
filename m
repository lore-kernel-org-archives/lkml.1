Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYFHPLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYFHPLI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 11:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbYFHPKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 11:10:54 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:50731 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbYFHPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 11:10:53 -0400
Message-ID: <484BF662.9070100@kernel.org>
Date: Sun, 08 Jun 2008 08:10:26 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ linus-git ] prctl(PR_SET_KEEPCAPS, ...) is broken for some
 configs, e.g. CONFIG_SECURITY_SELINUX
References: <1212932321.4675.9.camel@earth>
In-Reply-To: <1212932321.4675.9.camel@earth>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Nacked-by: Andrew G. Morgan <morgan@kernel.org>

In a configuration in which you are not using capabilities, what is the
"keep capabilities" operation supposed to do? Lie to you?

http://bugzilla.kernel.org/show_bug.cgi?id=10748

Cheers

Andrew

Dmitry Adamushko wrote:
|
| The following move-it-back-to-generic-place patch fixes the problem.
|
|
| ---
| From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
| Subject: fix prctl()'s handling of PR_{SET,GET}_KEEPCAPS
|
| with the commit 3898b1b4ebff8dcfbcf1807e0661585e06c9a91c
|
| prctl(PR_SET_KEEPCAPS, {1 | 0}, 0, 0, 0);
|
| always returns -EINVAL for the following configs:
|
| 1) CONFIG_SECURITY but without any of CONFIG_SECURITY_* modules;
|
| 2) CONFIG_SECURITY + CONFIG_SECURITY_SELINUX +
CONFIG_SECURITY_SELINUX_DISABLE
|
| both fall back to 'dummy' implementation.
|
| 3) CONFIG_SECURITY + CONFIG_SECURITY_SELINUX
|
| for this config it will work when there is a secondary security module.
|
| Here is what happens:
|
| Processing of PR_SET_KEEPCAPS (and a couple of other options) has been
| moved from kernel/sys.c::sys_prctl() to
security/commoncap.c::cap_task_prctl().
|
| For the aforementioned configs cap_task_prctl() is not called
| (moreover, security/commoncap.c is not compiled).
|
| SELinux's implementation of .task_prctl callback resorts to
| secondary_ops->task_prctl() which is dummy_task_prctl() (in the
| absence of CONFIG_SECURITY_CAPABILITIES (or any other) as a secondary
| module).
|
| So the relevant code should be either moved back to sys_prctl() or
| placed in some generic function (not in security/commoncap.c) which is
| accessible for all configs.
|
| Move it back to sys_prctl().
|
| Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
|
| ----
|
| diff --git a/kernel/sys.c b/kernel/sys.c
| index 14e9728..5b8e583 100644
| --- a/kernel/sys.c
| +++ b/kernel/sys.c
| @@ -24,6 +24,7 @@
|  #include <linux/times.h>
|  #include <linux/posix-timers.h>
|  #include <linux/security.h>
| +#include <linux/securebits.h>
|  #include <linux/dcookies.h>
|  #include <linux/suspend.h>
|  #include <linux/tty.h>
| @@ -1658,6 +1659,21 @@ asmlinkage long sys_prctl(int option, unsigned
long arg2, unsigned long arg3,
|  		return error;
|
|  	switch (option) {
| +		case PR_GET_KEEPCAPS:
| +			if (issecure(SECURE_KEEP_CAPS))
| +				error = 1;
| +			break;
| +		case PR_SET_KEEPCAPS:
| +			if (arg2 > 1) /* Note, we rely on arg2 being unsigned here */
| +				error = -EINVAL;
| +			else if (issecure(SECURE_KEEP_CAPS_LOCKED))
| +				error = -EPERM;
| +			else if (arg2)
| +				current->securebits |= issecure_mask(SECURE_KEEP_CAPS);
| +			else
| +				current->securebits &=
| +					~issecure_mask(SECURE_KEEP_CAPS);
| +			break;
|  		case PR_SET_PDEATHSIG:
|  			if (!valid_signal(arg2)) {
|  				error = -EINVAL;
| @@ -1744,6 +1760,12 @@ asmlinkage long sys_prctl(int option, unsigned
long arg2, unsigned long arg3,
|  		case PR_SET_TSC:
|  			error = SET_TSC_CTL(arg2);
|  			break;
| +		case PR_CAPBSET_READ:
| +			if (!cap_valid(arg2))
| +				error = -EINVAL;
| +			else
| +				error = !!cap_raised(current->cap_bset, arg2);
| +			break;
|  		default:
|  			error = -EINVAL;
|  			break;
| diff --git a/security/commoncap.c b/security/commoncap.c
| index 5edabc7..76f3a76 100644
| --- a/security/commoncap.c
| +++ b/security/commoncap.c
| @@ -576,12 +576,6 @@ int cap_task_prctl(int option, unsigned long
arg2, unsigned long arg3,
|  	long error = 0;
|
|  	switch (option) {
| -	case PR_CAPBSET_READ:
| -		if (!cap_valid(arg2))
| -			error = -EINVAL;
| -		else
| -			error = !!cap_raised(current->cap_bset, arg2);
| -		break;
|  #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
|  	case PR_CAPBSET_DROP:
|  		error = cap_prctl_drop(arg2);
| @@ -631,22 +625,6 @@ int cap_task_prctl(int option, unsigned long
arg2, unsigned long arg3,
|
|  #endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
|
| -	case PR_GET_KEEPCAPS:
| -		if (issecure(SECURE_KEEP_CAPS))
| -			error = 1;
| -		break;
| -	case PR_SET_KEEPCAPS:
| -		if (arg2 > 1) /* Note, we rely on arg2 being unsigned here */
| -			error = -EINVAL;
| -		else if (issecure(SECURE_KEEP_CAPS_LOCKED))
| -			error = -EPERM;
| -		else if (arg2)
| -			current->securebits |= issecure_mask(SECURE_KEEP_CAPS);
| -		else
| -			current->securebits &=
| -				~issecure_mask(SECURE_KEEP_CAPS);
| -		break;
| -
|  	default:
|  		/* No functionality available - continue with default */
|  		return 0;
|
| ---
|
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIS/Zf+bHCR3gb8jsRAqY0AKCX9tOKFdyc8IuCZS22JQH36SzVTQCfTtuS
GKGXZut41bhPGj2WPeh61DU=
=NvfJ
-----END PGP SIGNATURE-----

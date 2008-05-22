Return-Path: <linux-kernel-owner+w=401wt.eu-S935638AbYEVNIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935638AbYEVNIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 09:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762634AbYEVNII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 09:08:08 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:38847 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762473AbYEVNIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 09:08:07 -0400
Message-ID: <48357017.5060206@kernel.org>
Date: Thu, 22 May 2008 06:07:35 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Shi Weihua <shiwh@cn.fujitsu.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jmorris@namei.org,
       ltp-list@lists.sourceforge.net
Subject: Re: [PATCH] fix sys_prctl() returned uninitialized value
References: <4834E639.2010209@cn.fujitsu.com>	<20080521203212.ddf05254.akpm@linux-foundation.org>	<4834FE1D.10909@kernel.org> <20080521222551.8d8e064a.akpm@linux-foundation.org>
In-Reply-To: <20080521222551.8d8e064a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Acked-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew

Andrew Morton wrote:
| On Wed, 21 May 2008 22:01:17 -0700 "Andrew G. Morgan"
<morgan@kernel.org> wrote:
|
|> this is the default expected by the subsequent switch ().
|>
|> Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
|> ---
|>  kernel/sys.c |    2 ++
|>  1 files changed, 2 insertions(+), 0 deletions(-)
|>
|> diff --git a/kernel/sys.c b/kernel/sys.c
|> index 895d2d4..cb25a64 100644
|> --- a/kernel/sys.c
|> +++ b/kernel/sys.c
|> @@ -1657,6 +1657,8 @@ asmlinkage long sys_prctl(int option, unsigned
long arg2, unsigned long arg3,
|>  	if (security_task_prctl(option, arg2, arg3, arg4, arg5, &error))
|>  		return error;
|>
|> +	error = 0;
|> +
|>  	switch (option) {
|>  		case PR_SET_PDEATHSIG:
|>  			if (!valid_signal(arg2)) {
|
| Looking at it some more there are two cases which don't initialise
| `error': PR_SET_PDEATHSIG and PR_SET_DUMPABLE.  (let's set aside the
| silliness of having sys_prctl() perform set_dumpable()'s argument
| checking for it).
|
| So I would propose this fix, mainly because it removes that nasty
| uninitialized_var().  Please review carefully.
|
|
|
| From: Shi Weihua <shiwh@cn.fujitsu.com>
|
| If none of the switch cases match, the PR_SET_PDEATHSIG and
| PR_SET_DUMPABLE cases of the switch statement will never write to local
| variable `error'.
|
| Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>
| Cc: Andrew G. Morgan <morgan@kernel.org>
| Cc: "Serge E. Hallyn" <serue@us.ibm.com>
| Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
| ---
|
|  kernel/sys.c |    6 ++----
|  1 file changed, 2 insertions(+), 4 deletions(-)
|
| diff -puN kernel/sys.c~sys_prctl-fix-return-of-uninitialized-value
kernel/sys.c
| --- a/kernel/sys.c~sys_prctl-fix-return-of-uninitialized-value
| +++ a/kernel/sys.c
| @@ -1652,7 +1652,7 @@ asmlinkage long sys_umask(int mask)
|  asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned
long arg3,
|  			  unsigned long arg4, unsigned long arg5)
|  {
| -	long uninitialized_var(error);
| +	long error = 0;
|
|  	if (security_task_prctl(option, arg2, arg3, arg4, arg5, &error))
|  		return error;
| @@ -1701,9 +1701,7 @@ asmlinkage long sys_prctl(int option, un
|  			error = PR_TIMING_STATISTICAL;
|  			break;
|  		case PR_SET_TIMING:
| -			if (arg2 == PR_TIMING_STATISTICAL)
| -				error = 0;
| -			else
| +			if (arg2 != PR_TIMING_STATISTICAL)
|  				error = -EINVAL;
|  			break;
|
| _
|
| --
| To unsubscribe from this list: send the line "unsubscribe
linux-security-module" in
| the body of a message to majordomo@vger.kernel.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFINXAX+bHCR3gb8jsRAl4JAJ0djex041bKhq2gvcwUdJpfjSt9+gCeI4g0
uh1GZlx9WxoeU4ztcOV2kHI=
=c1Dw
-----END PGP SIGNATURE-----

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbYJUFyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbYJUFyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 01:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYJUFxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 01:53:52 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:40346 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYJUFxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 01:53:52 -0400
Message-ID: <48FD6E49.6060104@kernel.org>
Date: Mon, 20 Oct 2008 22:53:13 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       viro@zeniv.linux.org.ok, sgrubb@redhat.com, serue@us.ibm.com
Subject: Re: [PATCH 3/4] AUDIT: audit when fcaps increase the permitted or
 inheritable capabilities
References: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com> <20081020222612.3895.6710.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081020222612.3895.6710.stgit@paris.rdu.redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Eric Paris wrote:
> Any time fcaps are used to increase a processes pP or pE we will crate a new
> audit record which contains the entire set of known information about the 
> executable in question, fP, fI, fE, version and includes the parent processes
> pE, pI, pP.  This record type will only be emitted from execve syscalls.

I'm confused by the choice of when to log this event.

File capabilities are required to give a process 'any' active
capabilities. That is they don't affect pI -> pI', but without fI or fP,
the post-execve() process is guaranteed to have no pP or pE capabilities.

Logging execve()s where there is only an increase in capabilities seems
wrong to me. To me it seems equally important to log any event where an
execve() yields pP != 0.

> diff --git a/security/commoncap.c b/security/commoncap.c
> index 888b292..9bb285d 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -8,6 +8,7 @@
>   */
>  
>  #include <linux/capability.h>
> +#include <linux/audit.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> @@ -320,6 +321,8 @@ static int get_file_caps(struct linux_binprm *bprm)
>  
>  	rc = bprm_caps_from_vfs_caps(&vcaps, bprm);
>  
> +	audit_log_bprm_fcaps(bprm, &vcaps);
> +

When rc != 0, the execve() will fail. Is it appropriate to log in this case?

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFI/W5F+bHCR3gb8jsRAhM9AJ9oJL4PmdtMwHEkN0Xh0ZTHBlJPzgCfVT/8
1Rq4wgGWftqpaVXBmeAsEi8=
=W8R9
-----END PGP SIGNATURE-----

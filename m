Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbYBSRrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbYBSRrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 12:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbYBSRrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 12:47:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:2578 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbYBSRrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:47:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hCcuh1wOUmEy8vT4hI5Zp2qw9TUIbrJbbNEuq25ycKZFSHtNrX7DDn7t9XmH2x/RizeJb42A/DHDlvpXFP0KgElBWcCv1npJSSe5lGPuFVWbCUvTvIwEodzXRex5mEPaPy7owaZj/f0SOSYxWa4dVzyNpWvkM0Fkrm94qtC9CfA=
Date: Tue, 19 Feb 2008 18:45:42 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Roel Kluin <12o3l@tiscali.nl>, Evgeniy Dushistov <dushistov@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ufs: [bl]e*_add_cpu conversion
Message-ID: <20080219174524.GA6096@joi>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com> <1202857582-15450-18-git-send-email-marcin.slusarz@gmail.com> <47B2BB58.5040401@tiscali.nl> <20080215212815.26117a19.akpm@linux-foundation.org> <47BA132B.4050005@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BA132B.4050005@tiscali.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 12:22:19AM +0100, Roel Kluin wrote:
> Andrew Morton wrote:
> > On Wed, 13 Feb 2008 10:41:44 +0100 Roel Kluin <12o3l@tiscali.nl> wrote:
> > 
> >> you may also want these:
> >> ---
> >> [bl]e_add_cpu conversion in return
> 
> > upsets powerpc (at least):
> > 
> > fs/ufs/swab.h: In function `fs64_add':
> > fs/ufs/swab.h:47: warning: passing arg 1 of `le64_add_cpu' from incompatible pointer type
> > fs/ufs/swab.h:49: warning: passing arg 1 of `be64_add_cpu' from incompatible pointer type
> > fs/ufs/swab.h: In function `fs64_sub':
> > fs/ufs/swab.h:58: warning: passing arg 1 of `le64_add_cpu' from incompatible pointer type
> > fs/ufs/swab.h:60: warning: passing arg 1 of `be64_add_cpu' from incompatible pointer type
> 
> sorry for this. Is it correct to cast like the patch below does?
I don't think so. Their prototypes are wrong. We can:
a) remove fs64_add and fs64_sub as nobody use them
b) fix them - change second parameter do __fs64 (and convert to [bl]e64_add_cpu)

Evgeniy?

> If not (anyone) feel free to correct and send a patch yourself.
> The patch below was *not* tested
> ---
> [bl]e_add_cpu conversion in return (with cast)
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/fs/ufs/swab.h b/fs/ufs/swab.h
> index 1683d2b..594d6e8 100644
> --- a/fs/ufs/swab.h
> +++ b/fs/ufs/swab.h
> @@ -44,18 +44,22 @@ static __inline u32
>  fs64_add(struct super_block *sbp, u32 *n, int d)
>  {
>  	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
> -		return *n = cpu_to_le64(le64_to_cpu(*n)+d);
> +		le64_add_cpu((__le64 *)n, d);
>  	else
> -		return *n = cpu_to_be64(be64_to_cpu(*n)+d);
> +		be64_add_cpu((__le64 *)n, d);
> +
> +	return *n;
>  }
>  
>  static __inline u32
>  fs64_sub(struct super_block *sbp, u32 *n, int d)
>  {
>  	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
> -		return *n = cpu_to_le64(le64_to_cpu(*n)-d);
> +		le64_add_cpu((__le64 *)n, -d);
>  	else
> -		return *n = cpu_to_be64(be64_to_cpu(*n)-d);
> +		be64_add_cpu((__le64 *)n, -d);
> +
> +	return *n;
>  }
>  
>  static __inline u32

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZBXELW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZBXELW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 23:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZBXELN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 23:11:13 -0500
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:35970 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752902AbZBXELM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 23:11:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=nBj01PkoBr5LdrMRPgeOEFSuLiMsf9tGpO0JpOscPLaIjm8qxnHQygthkyYnZ7n92CP6O2qcmqnBSCWBCDoykLMLIcZrFyrt93NIDw0RrK+0GsnmfRPEwK8wSXdRgvuePEci8Zf7Ofc4M4EtcaVlTvxu/joWc9Feks+NgLuDGRc=  ;
X-YMail-OSG: n5brpFYVM1l2WeMaEgx30d5XsoXbNLa47NQehFOGNpWoj1ZF079QUoSa8innuq5ZLnesBQYGc8OjBzzIOF1O1G1UZScpLcLAPDlaNIVHWKGTDg40k_MXPdd4goc_Ck6rELDjwW5ErLHP.OHkeZfx5VWkwvII0cMqUn2juiyb4FxZd3uZOtHI.scOH29auZM5_e16NhTlVnxKmgysv5N9_VOSQzsXO1iY
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Salman Qazi <sqazi@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, davem@davemloft.net
Subject: Re: Performance regression in write() syscall
Date: Tue, 24 Feb 2009 15:10:32 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
References: <20090224020304.GA4496@google.com>
In-Reply-To: <20090224020304.GA4496@google.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902241510.33911.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added some ccs

On Tuesday 24 February 2009 13:03:04 Salman Qazi wrote:
> While the introduction of __copy_from_user_nocache (see commit:
> 0812a579c92fefa57506821fa08e90f47cb6dbdd) may have been an improvement
> for sufficiently large writes, there is evidence to show that it is
> deterimental for small writes.  Unixbench's fstime test gives the
> following results for 256 byte writes with MAX_BLOCK of 2000:
>
>     2.6.29-rc6 ( 5 samples, each in KB/sec ):
>     283750, 295200, 294500, 293000, 293300
>
>     2.6.29-rc6 + this patch (5 samples, each in KB/sec):
>     313050, 3106750, 293350, 306300, 307900
>
>     2.6.18
>     395700, 342000, 399100, 366050, 359850

What does unixbench's fstime test do? If it is just writing to the
pagecache, then this would be unexpected. If it is reading and writing,
then perhaps this could be a problem, but how realistic is it for a
performance critical application to read data out of the pagecache that
it has recently written? Do you have something at google actually doing
real work that speeds up with this patch?


>     See w_test() in src/fstime.c in unixbench version 4.1.0.  Basically,
> the above test consists of counting how much we can write in this manner:
>
>     alarm(10);
>     while (!sigalarm) {
>             for (f_blocks = 0; f_blocks < 2000; ++f_blocks) {
>                    write(f, buf, 256);
>             }
>             lseek(f, 0L, 0);
>     }
>
> I realised that there are other components to the write syscall regression
> that are not addressed here.  I will send another email shortly stating the
> source of another one.
>
> Signed-off-by: Salman Qazi <sqazi@google.com>
> ---
> diff --git a/arch/x86/include/asm/uaccess_64.h
> b/arch/x86/include/asm/uaccess_64.h index 84210c4..efe7315 100644
> --- a/arch/x86/include/asm/uaccess_64.h
> +++ b/arch/x86/include/asm/uaccess_64.h
> @@ -192,14 +192,20 @@ static inline int __copy_from_user_nocache(void *dst,
> const void __user *src, unsigned size)
>  {
>  	might_sleep();
> -	return __copy_user_nocache(dst, src, size, 1);
> +	if (likely(size >= PAGE_SIZE))
> +		return __copy_user_nocache(dst, src, size, 1);
> +	else
> +		return __copy_from_user(dst, src, size);
>  }
>
>  static inline int __copy_from_user_inatomic_nocache(void *dst,
>  						    const void __user *src,
>  						    unsigned size)
>  {
> -	return __copy_user_nocache(dst, src, size, 0);
> +	if (likely(size >= PAGE_SIZE))
> +		return __copy_user_nocache(dst, src, size, 0);
> +	else
> +		return __copy_from_user_inatomic(dst, src, size);
>  }
>
>  unsigned long



Return-Path: <linux-kernel-owner+w=401wt.eu-S932161AbYEGS60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbYEGS60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759131AbYEGS6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:58:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:48754 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507AbYEGS6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:58:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PHXSeD2kZp2xJ8p4t7vDU4vhyc3Z/PNTzEEe0ScuruUex0bsOKpq334/AAoqDJ9U2f/T7M3ybz6AqaTVBmMcn4ayam8ZG16Qt9PFVrliG1j70okxV5vznyMa+yf65Vo40FIFfQiz5OM4G4NQugnuo1BSSeObSVfAR9Tw/LgjN3A=
Date: Wed, 7 May 2008 23:53:17 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Soumyadip Das Mahapatra <dip_kernel@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: improved strnicmp in lib/string.c
Message-ID: <20080507195317.GA5131@martell.zuzino.mipt.ru>
References: <116786.40929.qm@web94104.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <116786.40929.qm@web94104.mail.in2.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 11:51:09PM +0530, Soumyadip Das Mahapatra wrote:
> This is somewhat improved version of strnicmp() function in lib/string.c.

Familiarize youself with coding style before sending patches, see
kernel/sched.c , fs/dcache.c for good examples.

>I have implemented binary
> comparison  rather than linear one(which was in the older version).

Obviously buggy.

> --- 2.6.25-vanilla/lib/string.c
> +++ 2.6.25-hacked/lib/string.c
> @@ -31,32 +10,43 @@
>   * @s2: The other string
>   * @len: the maximum number of characters to compare
>   */
> +/* This is somewhat faster
> + * method compared to the
> + * olderone (in case of a large string)
> + */
>  int strnicmp(const char *s1, const char *s2, size_t len)
>  {
> -    /* Yes, Virginia, it had better be unsigned */
> -    unsigned char c1, c2;
> -
> -    c1 = c2 = 0;
> -    if (len) {
> -        do {
> -            c1 = *s1;
> -            c2 = *s2;
> -            s1++;
> -            s2++;
> -            if (!c1)
> -                break;
> -            if (!c2)
> -                break;
> -            if (c1 == c2)
> -                continue;
> -            c1 = tolower(c1);
> -            c2 = tolower(c2);
> -            if (c1 != c2)
> +    /* Yes, i am keeping 'em unsigned too */
> +    unsigned char c1, c2, c3, c4;
> +    unsigned count = 0;
> +    int flag = -1;
> +
> +    c1 = c2 = c3 = c4 = 0;
> +
> +    if(len > 0)
> +    {
> +        for(; count <= len/2; count++)
> +        {
> +            c1 = tolower(s1[count]);    // well, we
> +            c2 = tolower(s2[count]);    // are ignoring
> +            c3 = tolower(s1[len-count-1]);    // cases
> +            c4 = tolower(s2[len-count-1]);    // thats why

Buggy.

> +            
> +            if(c1 == c2)
> +            {
> +                if(c3 != c4)
> +                {
> +                    flag = 1;
> +                    break;
> +                }
> +            }
> +            else
>                  break;
> -        } while (--len);
> +            flag = 0;
> +        }
>      }
> -    return (int)c1 - (int)c2;
> -}
> +    return flag;     // return 0 for matching and 
> +}            // nonzero for mismatch
>  EXPORT_SYMBOL(strnicmp);
>  #endif

And this function is called at most ~100 character strings, so nobody
cares about its performance.


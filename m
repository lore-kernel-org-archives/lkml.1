Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZKBSwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZKBSwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbZKBSwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:52:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:35225 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082AbZKBSwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:52:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=j6u6DNBy+eD91mv8Gu+kHSCI8FDqofjp0PSpaaY0LzADRo4keUbCq2Tlq6/4ZBOcmi
         TowQ9MKXfyzF/HKWyZ0pf+2U3l5CtJxnqo09YqY/2Pr+qNqG0ndIxXKqxbhLjMao7SYk
         p9imxJSD2X/QBvL4Lcr10pHeBN0Od0UPqibIs=
Date: Mon, 2 Nov 2009 19:52:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: laijs@cn.fujitsu.com, mingo@elte.hu, davem@davemloft.net,
       akpm@linux-foundation.org, harvey.harrison@gmail.com,
       linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/7] vsprintf: move local vars to block local vars
	and remove unneeded ones
Message-ID: <20091102185249.GB4880@nowhere>
References: <b8bf37780911020926p2c9e0fccva255c003b563c3ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8bf37780911020926p2c9e0fccva255c003b563c3ed@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 03:26:48PM -0200, André Goddard Rosa wrote:
> From 636fc10ec894c83ba3b73433fee6df94529bc930 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
> Date: Sun, 1 Nov 2009 14:04:37 -0200
> Subject: [PATCH v2 6/7] vsprintf: move local vars to block local vars
> and remove unneeded ones
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> It also decreases code size:
>    text    data     bss     dec     hex filename
>   15719       0       8   15727    3d6f lib/vsprintf.o-before
>   15703       0       8   15711    3d5f lib/vsprintf.o-after



Actually, moving variable scope from function local to block
local is nice for code reviewing, it increases the code readability.
And this is a more important impact than binary code size IMO.


 
> @@ -1616,7 +1609,9 @@ int bstr_printf(char *buf, size_t size, const
> char *fmt, const u32 *bin_buf)
>  			spec.precision = get_arg(int);
>  			break;
> 
> -		case FORMAT_TYPE_CHAR:
> +		case FORMAT_TYPE_CHAR: {
> +			char c;
> +
>  			if (!(spec.flags & LEFT)) {
>  				while (--spec.field_width > 0) {
>  					if (str < end)
> @@ -1634,11 +1629,11 @@ int bstr_printf(char *buf, size_t size, const
> char *fmt, const u32 *bin_buf)
>  				++str;
>  			}
>  			break;
> +		}
> 
>  		case FORMAT_TYPE_STR: {
>  			const char *str_arg = args;
> -			size_t len = strlen(str_arg);
> -			args += len + 1;
> +			args += strlen(str_arg) + 1;
>  			str = string(str, end, (char *)str_arg, spec);
>  			break;
>  		}
> @@ -1655,6 +1650,10 @@ int bstr_printf(char *buf, size_t size, const
> char *fmt, const u32 *bin_buf)
>  			++str;
>  			break;
> 
> +		/*
> +		 * Merging this handling with the above one increases code size!
> +		 * Why, gcc, why?!
> +		 */
>  		case FORMAT_TYPE_INVALID:



Please do this merge:

@@ -1633,11 +1633,6 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
                        break;
 
                case FORMAT_TYPE_PERCENT_CHAR:
-                       if (str < end)
-                               *str = '%';
-                       ++str;
-                       break;
-
                case FORMAT_TYPE_INVALID:
                        if (str < end)
                                *str = '%';

We don't care that much about binary code size in vsprintf.c
Code readability has a really higher priority over binary code size
here.


The rest looks good.


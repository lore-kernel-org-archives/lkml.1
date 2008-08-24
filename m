Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbYHXPO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbYHXPO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 11:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYHXPOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 11:14:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:16185 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYHXPOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 11:14:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Qvqvqx+TGr24pNL0ouYFPh+GDZUNMIFWnG45c8RighKP7Q3Jb3Nl4lKlwf/63OB67I
         lDNz+WOYwx/yGi9h/AIc1KSZj0OqSyVWN18c4TpF9FYllqt+RDTRKJdZKUxW0pin1Cs8
         qdhPYqEVpL5OOIWpwkDAG388mjjI3843Cfb9s=
Message-ID: <84144f020808240814l41be03a6x53d4c521d7d95eb6@mail.gmail.com>
Date: Sun, 24 Aug 2008 18:14:47 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eric Sesterhenn" <snakebyte@gmx.de>
Subject: Re: [Patch] Fix Buffer overflow in hfsplus with a corrupted image
Cc: zippel@linux-m68k.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080824130736.GA27742@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080824130736.GA27742@alice>
X-Google-Sender-Auth: 7c309f4008b21312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Sun, Aug 24, 2008 at 4:07 PM, Eric Sesterhenn <snakebyte@gmx.de> wrote:
> when an hfsplus image gets corrupted it might happen that the catalog
> namelength field gets b0rked. If we mount such an image
> the memcpy() in hfsplus_cat_build_key_uni() writes more than the 255
> that fit in the name field. Depending on the size of the overwritten
> data, we either only get memory corruption or also trigger an oops like
> this:
>
> --- linux/fs/hfsplus/catalog.c.orig     2008-08-24 14:52:03.000000000 +0200
> +++ linux/fs/hfsplus/catalog.c  2008-08-24 14:54:15.000000000 +0200
> @@ -168,6 +168,11 @@ int hfsplus_find_cat(struct super_block
>                return -EIO;
>        }
>
> +       if (be16_to_cpu(tmp.thread.nodeName.length) >= 127) {
> +               printk(KERN_ERR "hfs: catalog name length corrupted\n");
> +               return -EIO;
> +       }

So, where does this 127 come from? I can only find reference to a
maximum length of 255 unicode characters (16 bits per character) in
the following technical note for HFS+ (see sections "HFS Plus Names"
and "Catalog Thread Records"):

  http://developer.apple.com/technotes/tn/tn1150.html

Hmm?

                        Pekka

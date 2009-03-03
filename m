Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbZCCDNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbZCCDNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 22:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbZCCDNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 22:13:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753910AbZCCDNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 22:13:41 -0500
Date: Mon, 2 Mar 2009 19:12:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mike Murphy <mamurph@cs.clemson.edu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org, greg@kroah.com,
       oliver@neukum.org, fweisbec@gmail.com
Subject: Re: PATCH [1/3] drivers/input/xpad.c: Improve Xbox 360 wireless 
 support and add sysfs interface
In-Reply-To: <5aa163d00903021847n525e8704jd332610c45e4675a@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0903021902460.3111@localhost.localdomain>
References: <5aa163d00902282053h38b0febbyb37fc30855fdc985@mail.gmail.com>  <20090302130425.23cc628d.akpm@linux-foundation.org> <5aa163d00903021847n525e8704jd332610c45e4675a@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Mar 2009, Mike Murphy wrote:
> 
> 3. The outer cast (__s16) converts the unsigned values to signed
> values, while the "~" inverts the y axes to make them function like a
> joystick instead of a flight simulator control.

You should do the ~ before the cast, or use - if you just want to reverse 
things. It probably doesn't much matter (the difference between ~ and - i 
just one), but still..

Also, quite frankly, it looks like your 'coords[]' array should just be of 
type 's16' (rather than 'int') to begin with. You seem to really never use 
it as an int anyway. That would get rid of the cast.

> Is there a cleaner way to accomplish the transition from 16-bit
> unsigned little endian to 16-bit signed host endian?

I think the code is fine, but I think you'd be better off if the "data" 
pointer was perhaps of type "le16 *" to begin with.

That obviously means that your "offset" addition should now be in 16-bit 
words rather than in bytes, so you'd need to divide the offsets by two to 
do that, but those are just numbers anyway. And quite frankly, it looks 
like the actual data is just offset differently - but with the same fixed 
offset between values - for the two cases, so you could just have _one_ 
offset (and even just add that into the 'data' pointer).

That would get rid of the second cast. You'd end up with just

	s16 coords[4];

	/* In words - so this is 12 vs 6 bytes into the data */
	data += (xpad->xtype == XTYPE_XBOX) ? 6 : 3;

	coords[0] = le16_to_cpup(data);
	coords[1] = ~le16_to_cpup(data + 1);
	coords[2] = le16_to_cpup(data + 2);
	coords[3] = ~le16_to_cpup(data + 3);
	..

which looks a bit shorter and avoids those casts. I dunno.

		Linus

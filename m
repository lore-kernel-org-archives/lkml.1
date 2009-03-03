Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZCCEQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZCCEQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 23:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZCCEQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 23:16:14 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:44494 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZCCEQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 23:16:13 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0903021902460.3111@localhost.localdomain>
References: <5aa163d00902282053h38b0febbyb37fc30855fdc985@mail.gmail.com>
	 <20090302130425.23cc628d.akpm@linux-foundation.org>
	 <5aa163d00903021847n525e8704jd332610c45e4675a@mail.gmail.com>
	 <alpine.LFD.2.00.0903021902460.3111@localhost.localdomain>
Date: Mon, 2 Mar 2009 23:16:10 -0500
X-Google-Sender-Auth: c066a78402b60e21
Message-ID: <5aa163d00903022016s14b7ad32qfbaf82a07b9e0921@mail.gmail.com>
Subject: Re: PATCH [1/3] drivers/input/xpad.c: Improve Xbox 360 wireless 
	support and add sysfs interface
From: Mike Murphy <mamurph@cs.clemson.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org, greg@kroah.com,
       oliver@neukum.org, fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 10:12 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> You should do the ~ before the cast, or use - if you just want to reverse
> things. It probably doesn't much matter (the difference between ~ and - i
> just one), but still..
>
> Also, quite frankly, it looks like your 'coords[]' array should just be of
> type 's16' (rather than 'int') to begin with. You seem to really never use
> it as an int anyway. That would get rid of the cast.
>
>> Is there a cleaner way to accomplish the transition from 16-bit
>> unsigned little endian to 16-bit signed host endian?
>
> I think the code is fine, but I think you'd be better off if the "data"
> pointer was perhaps of type "le16 *" to begin with.
>
> That obviously means that your "offset" addition should now be in 16-bit
> words rather than in bytes, so you'd need to divide the offsets by two to
> do that, but those are just numbers anyway. And quite frankly, it looks
> like the actual data is just offset differently - but with the same fixed
> offset between values - for the two cases, so you could just have _one_
> offset (and even just add that into the 'data' pointer).
>
> That would get rid of the second cast. You'd end up with just
>
>        s16 coords[4];
>
>        /* In words - so this is 12 vs 6 bytes into the data */
>        data += (xpad->xtype == XTYPE_XBOX) ? 6 : 3;
>
>        coords[0] = le16_to_cpup(data);
>        coords[1] = ~le16_to_cpup(data + 1);
>        coords[2] = le16_to_cpup(data + 2);
>        coords[3] = ~le16_to_cpup(data + 3);
>        ..
>
> which looks a bit shorter and avoids those casts. I dunno.
>
>                Linus
>

Thanks Linus... that solution worked, and it did make the code
shorter. To get a clean compile, I had to cast the actual argument
data pointer to (__le16 *), but that only adds 2 casts. I will send
the revision shortly.

Thanks,
Mike
-- 
Mike Murphy
Ph.D. Candidate and NSF Graduate Research Fellow
Clemson University School of Computing
120 McAdams Hall
Clemson, SC 29634-0974 USA
Tel: +1 864.656.2838   Fax: +1 864.656.0145
http://cirg.cs.clemson.edu/~mamurph

Return-Path: <linux-kernel-owner+w=401wt.eu-S935140AbZLGPDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935140AbZLGPDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932584AbZLGPDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:03:48 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:33203 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbZLGPDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:03:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Qy0f+qriVl13FtvgvOVTDLNBdYR2k49S7rbbP5kQ+woKEtICEWpm6udTeEpySIBc33
         OaXmVJPY9uN/BbI3icQIuSW1rBzH5tDq1sEprdTMQuaaT2G7Gzkliv4ruv7crs4dkQod
         wNGqZ1pL+qP0qjQOPOREZaiicFgULcfCZZci8=
MIME-Version: 1.0
In-Reply-To: <20091207141321.0964461d@lxorguk.ukuu.org.uk>
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu> <E1NHWlu-00029N-1t@pomaz-ex.szeredi.hu> 
	<20091207122346.6d18a8e1@lxorguk.ukuu.org.uk> <E1NHctp-00032C-A1@pomaz-ex.szeredi.hu> 
	<E1NHd0J-000345-Kw@pomaz-ex.szeredi.hu> <20091207130339.620b904b@lxorguk.ukuu.org.uk> 
	<E1NHdJy-00037l-Jb@pomaz-ex.szeredi.hu> <20091207131546.2af06647@lxorguk.ukuu.org.uk> 
	<E1NHdS9-00039i-B6@pomaz-ex.szeredi.hu> <20091207141321.0964461d@lxorguk.ukuu.org.uk>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 7 Dec 2009 10:03:33 -0500
X-Google-Sender-Auth: e7597d3d4f92fa6e
Message-ID: <cb0375e10912070703j4e5769c7tec6090378248a187@mail.gmail.com>
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 7, 2009 at 9:13 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > That is *exactly* the problem, which is clearly what you are missing here.
>>
>> I don't think so, but maybe I'm wrong.  Could you describe your attack
>> scenario in detail then, please?
>
> First obvious attack: get an O_NODE handle to a device you have assigned
> to your ownership
>
>        while(1)
>                fchmod(fd, 0666);
>
> wait for device to unload, reload and be intended for another user
> Race udev to a real open. You have a similar problem with vhangup() and
> ttys.

Huh?  I would've thought that udev would (and already does?), on
device unload, chown to 0:0, then chmod to 0000, then unlink, in which
case that attack doesn't work.

If you mean that someone could have an O_NODE handle open, then the
device unregisters, then, before udev has a chance to do anything at
all, a new device w/ the same major/minor numbers appears, then the
O_NODE handle owner upgrades to a real fd, then we have worse worries:
the attacker could just open the device node on disk without O_NODE,
hard links, or any other funny tricks.  revoke() wouldn't fix that
either.

I'll admit that O_NODE scares me a bit from a security perspective,
but so do hard links and /proc/self/fd in general, and I'm not really
convinced that there are any new attacks here.

Would you be okay with a patch that prevented opening
/proc/self/fd/xxx on O_NODE handles?  I personally don't care about
O_NODE all that much, but I'd like a decent in-kernel AFS
implementation (and a decent revoke() implementation, and especially
the ability to revoke whole filesystems would be really nice too).

--Andy

>
> This cannot happen with the existing kernel because there cannot be an
> open handle when the original device unload occurs[1] and it cannot happen
> with vhangup because the hangup is basically a special case revoke()
> implementation for tty devices.
>
> O_NODE changes the whole lifetime semantics for inodes. It's not
> something you can do casually. pioctl() gets this right although for the
> same reason as path based chmod/chown/etc all get it right, O_NODE breaks
> it all horribly.
>
> Alan
> [1] If you think about it a wait for no references is the same barrier as
> a revoke but a blocking one.
>

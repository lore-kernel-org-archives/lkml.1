Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbZLGPvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbZLGPvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZLGPvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:51:05 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58372 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZLGPvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:51:04 -0500
To: Andrew Lutomirski <luto@mit.edu>
CC: alan@lxorguk.ukuu.org.uk, miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <cb0375e10912070703j4e5769c7tec6090378248a187@mail.gmail.com>
	(message from Andrew Lutomirski on Mon, 7 Dec 2009 10:03:33 -0500)
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu> <E1NHWlu-00029N-1t@pomaz-ex.szeredi.hu> 
	<20091207122346.6d18a8e1@lxorguk.ukuu.org.uk> <E1NHctp-00032C-A1@pomaz-ex.szeredi.hu> 
	<E1NHd0J-000345-Kw@pomaz-ex.szeredi.hu> <20091207130339.620b904b@lxorguk.ukuu.org.uk> 
	<E1NHdJy-00037l-Jb@pomaz-ex.szeredi.hu> <20091207131546.2af06647@lxorguk.ukuu.org.uk> 
	<E1NHdS9-00039i-B6@pomaz-ex.szeredi.hu> <20091207141321.0964461d@lxorguk.ukuu.org.uk> <cb0375e10912070703j4e5769c7tec6090378248a187@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1NHfrW-0003YW-Rn@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 07 Dec 2009 16:50:58 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Andrew Lutomirski wrote:
> On Mon, Dec 7, 2009 at 9:13 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > First obvious attack: get an O_NODE handle to a device you have assigned
> > to your ownership
> >
> >        while(1)
> >                fchmod(fd, 0666);
> >
> > wait for device to unload, reload and be intended for another user
> > Race udev to a real open. You have a similar problem with vhangup() and
> > ttys.
> 
> Huh?  I would've thought that udev would (and already does?), on
> device unload, chown to 0:0, then chmod to 0000, then unlink, in which
> case that attack doesn't work.

Git version of udev does:

	chmod(filename, 0000);
	chown(filename, 0, 0);
	err = unlink(filename);

It should probably do it the other way round, which is how it was
originally, until this commit messed it up:

  commit 39087d3bdd0b5195c2570a4f858b88a82d42a066
  Author: Kay Sievers <kay.sievers@vrfy.org>
  Date:   Sat Aug 29 16:10:24 2009 +0200
  
      util_unlink_secure(): chmod() before chown()
  
      Suggested by Florian Zumbiehl <florz@florz.de>.

And the thread where it came from:

  http://markmail.org/thread/ozwcbju52yb3qs5d

where the poster actually warned Kay that it was wrong...

> Would you be okay with a patch that prevented opening
> /proc/self/fd/xxx on O_NODE handles?

We can't sanely do that.

Thanks,
Miklos

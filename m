Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYFXDRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYFXDRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 23:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbYFXDRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 23:17:36 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:40185 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754063AbYFXDRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 23:17:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wndlzPEWplRzjSuBquwp+yxXI5VdJarG0a61flOVCKduf5lfLyxQO2Q6rOYx4nU/BzWMT8sSp1Yt9leuJfbm6rpKi4YOF22waVDJg+tZ4fR5uXixNyWAakktcFbRWDI33rBVVaxXEqQAZbmq0FEM9qC5ppq5wTzSvCcFHV7O4Cs=  ;
X-YMail-OSG: Jdta0oAVM1koGKdzDrL5dkhtMETySkJ0UErRadr5Yb4ACCl3fwxtsUSt7Ci4beSrH7QJVfxf4Tae59Wr3fYc2_ttqjJWRf8rpHVYs.AJ69DBKdaZIT9QwPHxAubRRzuM4m8-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] ext3: don't read inode block if the buffer has a write error
Date: Tue, 24 Jun 2008 13:17:22 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, sct@redhat.com,
       adilger@sun.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jack@suse.cz,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
References: <485F8822.5030205@hitachi.com> <20080623191733.52c3491c.akpm@linux-foundation.org> <alpine.LFD.1.10.0806231958010.2926@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806231958010.2926@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241317.22470.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008 13:01, Linus Torvalds wrote:
> On Mon, 23 Jun 2008, Andrew Morton wrote:
> > > I don't know why it was done like this, or if anybody actually tested
> > > any of it, but AFAIKS the best way to fix this is to simply not
> > > clear any uptodate bits upon write errors.
> >
> > There's a plausible-sounding reason for this behaviour which I forgot
> > about three years ago.  Maybe Linus remembers?
>
> We have to drop the data at _some_ point. Maybe some errors are transient,
> but a whole lot aren't. Jank out your USB memory stick, and those writes
> will continue fail. So you can't just keep things dirty - and that also
> implies that the buffer sure as heck isn't up-to-date either.

Depends what semantics you want, I guess. I have the newest copy of the
data... yes you do unless you want to try to say that a write error to
the media somehow invalidates that fact.


> Yes, we could haev a "retry once or twice", but quite frankly, that has
> always been left to the low-level driver. By the time the buffer cache or
> page cache sees the error, it should be considered more than "transient",
> and the data in memory is simply not _useful_ any more.

It could be useful. For example if you have it mmapped (or even just
reading it back from pagecache) and working on it, then you really may
not want to lose all your program just because of the write error.

Keeping it around longer may allow you eg. to "save as something else".

Yes, we have to discard the page at some point, but I don't know if
this is the right place. Maybe a sysctl thing?


> So clearing the uptodate bit seems to be the logical thing to do. But on
> the other hand, it's probably not helping much either, so I don't
> personally care if we keep it "uptodate" - as long as the dirty bit
> doesn't get set, and as long as there is *some* way to get rid of the bad
> buffer later.

What you want to do is not insane, but the way it is currently being
done is. As I said, just clearing the uptodate bit might blow up your
kernel pretty quickly from assertions in the vm. It should be going
through the whole truncate or invalidate page machinery in order to
do that.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYDAJ0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYDAJ0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbYDAJ0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:26:04 -0400
Received: from lazybastard.de ([212.112.238.170]:45504 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbYDAJ0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:26:02 -0400
Date: Tue, 1 Apr 2008 11:25:48 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
Message-ID: <20080401092548.GC7465@logfs.org>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr> <47F0DD49.7010302@nokia.com> <20080331132047.GA31660@logfs.org> <47F1C78D.2050300@yandex.ru> <47F1CE9D.4080709@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47F1CE9D.4080709@nokia.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 April 2008 08:56:45 +0300, Artem Bityutskiy wrote:
>
> I asked you some time ago to describe how you maintain per-eraseblock
> space accounting [1]. E.g., how you select an eraseblock for garbage
> collection, how do you store the accounting information.
> 
> You said you find eraseblocks by scanning. This means logfs is not
> really scalable because you may spend ages before you find anything
> appropriate. When the FS is almost full, yo need to scan nearly
> whole flash to find an eraseblock? So if I mount a nearly full 
> FS, and start writing, I'll get my request handled when nearly whole
> media is scanned?

Correct.  I have a patch that caches this information in RAM, so the
worst-case scenario is to do the full scan once - if the filesystem is
near 100% full and performance is down the drain anyway.  The goal is
obviously to store that information on the medium.

And you get the obvious catch-22.  When writing out how much free space
exists in which blocks, you occupy some free space in one of those
blocks and obsolete some in another.  So by writing the data you have
just written changes and should be written again.

Takes a bit of thought to solve.

> UBIFS stores per-eraseblock information on the media in a B-tree, and
> it also has lists of empty/dirty eraseblocks, which allow to very quickly
> find the best eraseblock to garbage-collect or to write to.

So how do you solve the catch-22?

Jörn

-- 
Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it.
-- Brian W. Kernighan

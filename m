Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbYF2FDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbYF2FDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 01:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbYF2FDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 01:03:14 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:47883 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYF2FDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 01:03:13 -0400
Message-ID: <4867178D.50106@skyrush.com>
Date: Sat, 28 Jun 2008 23:03:09 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: James Cloos <cloos@jhcloos.com>
CC: linux-kernel@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org>	<4862DB28.3050001@skyrush.com> <48630286.2050006@skyrush.com>	<87wskck5wi.fsf@devron.myhome.or.jp> <48639863.808@skyrush.com>	<877iccxnwi.fsf@devron.myhome.or.jp> <4863B9AF.4080105@skyrush.com>	<87zlp8w4br.fsf@devron.myhome.or.jp> <4863CC89.9070705@skyrush.com> <m31w2h6vup.fsf@lugabout.jhcloos.org>
In-Reply-To: <m31w2h6vup.fsf@lugabout.jhcloos.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Cloos wrote:
> Joe> For a camera, since DST is not taken into account.  If you really
> Joe> want to set your camera to local time and are willing to accept the
> Joe> inherent issues, why not just use local time FAT behavior as it is
> Joe> now in Linux.
> 
> Taking the rôle of Devil’s Advocate, why presume that the camera and the
> box will have the same idea of local time?  One might set the camera to
> local time on a vacation, take some pics, return home and only them mount
> the card on one's box.

Hi James, I think you have hit squarely on the issue.  One could do
this, and the result would be potentially confusing and incorrect.

Say someone lives in Denver, and it is summer.  The UTC offset here is
-6 hours.  That person travels to the east coast, sets his camera to
local time there (UTC - 4), and takes a picture at 9:00am.  He then
returns to Denver and transfers the pic to his PC.  Using the current
Linux FAT mount behavior, the picture would be given a timestamp in
Linux of 15:00 UTC (9:00am local time in Denver, since the code
preserves the local time stamp, which is 9:00).  Now, the picture was
actually taken at 13:00 UTC (7:00am local time in Denver), and since UTC
is what matters in Linux, the actual time is two hours off.

In order to make sense of the timestamp on the picture, he would have to
remember where the picture was taken and do a time zone correction,
remembering that the picture was downloaded in Denver preserving local
time.  It's starting to get a bit mind-bending already, but see the
example of moving to England below for how it can get worse.

> It does seem likely that anyone who sets the camera's time at all will
> probably prefer localtime.  And if they know that one card has photos
> taken during a winter visit to Orlando, and another from a summer trip
> to Alaska, they may want to copy over accurate timestamps.

Some people will perfer the timestamps be in localtime, but this is
really problematic, since times in Linux's filesystems (ext3, etc.), and
even Windows' NTFS, are stored in UTC internally (which is a good thing).

Now things potentially get interesting...

Say that same person who took the picture on the east coast at 9:00am
(but timestamped 9:00am Denver time now) moves to England with his PC.
He then sets his computer's time zone to his new local time zone, and it
now says the picture was taken at 4:00pm!  He can no longer think of the
timestamp as local time, but then again it is not even correct in local
time where the picture was taken, since that would have been 11:00 east
coast time.

Now, if the guy had kept his camera on Denver time during his travels
and no DST change happened between taking the pictures and downloading
them, the correct timestamps would have been preserved (if DST status
was different, however, the timestamp would be off by one hour).  But if
one is going to pick a "universal time" that is not necessarily local
time for the camera while traveling, why not use UTC and avoid all of
the issues?

So I guess my point is that the option I propose will allow people to
set their cameras to UTC and thereby always get unambiguously correct
timestamps.  Plus there is no need to ever change the camera's clock
when traveling or when DST changes happen.  Not all people will choose
to operate this way, so it would be nice to have the choice.

						-Joe

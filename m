Return-Path: <linux-kernel-owner+w=401wt.eu-S934145AbYEFXgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145AbYEFXgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbYEFXg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:36:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57411 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186AbYEFXgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:36:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4820EB69.9090907@s5r6.in-berlin.de>
Date: Wed, 07 May 2008 01:36:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Alistair John Strachan <alistair@devzero.co.uk>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc1
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>	<20080504160904.GF19717@sgi.com>	<Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>	<200805060902.25835.alistair@devzero.co.uk>	<20080506073134.424780a3@gaivota>	<48206C73.80509@s5r6.in-berlin.de>	<20080506161346.183f367c@gaivota>	<4820B524.5080100@s5r6.in-berlin.de>	<20080506170623.53732e78@gaivota>	<4820C3D8.6040403@s5r6.in-berlin.de> <20080506193928.5acfc84d@gaivota>
In-Reply-To: <20080506193928.5acfc84d@gaivota>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> On Tue, 06 May 2008 22:47:20 +0200
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Or another idea:
>>
>> Copy _all_ dependencies of drivers which can be selected by "...if 
    ^^^^
>> VIDEO_HELPER_CHIPS_AUTO" to VIDEO_HELPER_CHIPS_AUTO.
> 
> I actually did this for tuners, on this changeset (still not at mainstream):
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=d10b3c6817fb3fed8e6cd6d64d47c187a615c952

Yes...  Except that it is very dangerous to /move/ dependencies, as you 
are apparently doing in that patch.  When you use "select" somewhere, 
you should generally /copy/ dependencies.

Although something like

config VIRTUAL_META_OPTION
	depends on REAL_DEPENDENCY

config THE_REAL_THING
	depends on VIRTUAL_META_OPTION

does work if THE_REAL_THING actually depends on REAL_DEPENDENCY, it is 
safer if this dependency stays there, i.e.

config THE_REAL_THING
	depends on REAL_DEPENDECY

or

config THE_REAL_THING
	depends on REAL_DEPENDENCY && VIRTUAL_META_OPTION

or whatever, or equivalent constructs involving "if"..."endif".

(I presume that for example MEDIA_TUNER_TDA827X does indeed have a build 
dependency on DVB_CORE && I2C.)

Or in other words:

Since MEDIA_TUNER selects a bunch of options which itself have build 
dependencies, you /must/ duplicate all of their dependencies to 
MEDIA_TUNER.  Well, actually you don't use plain "select", you use 
"select ... if !MEDIA_TUNER_CUSTOMIZE".  So if you can ensure by other 
means that those 2nd level dependencies are guaranteed to be fulfilled 
whenever MEDIA_TUNER_CUSTOMIZE=n, then you don't need to duplicate the 
2nd level dependencies into MEDIA_TUNER.

That's the same what I meant in my comment on VIDEO_HELPER_CHIPS_AUTO:

Those options which "select" video decoders generally /must/ contain 
duplicates of the dependency statements of the decoders which they 
select.  Except, since you don't use plain "select" there but actually 
"select ... if VIDEO_HELPER_CHIPS_AUTO", you can alternatively put the 
duplicates of the dependency statements to VIDEO_HELPER_CHIPS_AUTO.
-- 
Stefan Richter
-=====-==--- -=-= --===
http://arcgraph.de/sr/

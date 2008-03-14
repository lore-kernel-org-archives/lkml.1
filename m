Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYCNPrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYCNPrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 11:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbYCNPro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 11:47:44 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:59467 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbYCNPrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 11:47:43 -0400
Message-ID: <47DA9DF8.5010600@emc.com>
Date: Fri, 14 Mar 2008 11:47:04 -0400
From: Ric Wheeler <ric@emc.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Benny Amorsen <benny+usenet@amorsen.dk>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803110450.19390.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de> <200803111602.53835.phillips@phunq.net> <m3d4q08477.fsf@ursa.amorsen.dk> <20080312133001.1668f40d@the-village.bc.nu> <20080314093019.GA5966@ucw.cz> <47DA5C8D.2020207@emc.com> <m3fxutcz2s.fsf@ursa.amorsen.dk> <20080314125656.GA7412@mit.edu>
In-Reply-To: <20080314125656.GA7412@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.53115
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, __C230066_P2 0, __CP_MEDIA_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Fri, Mar 14, 2008 at 12:41:31PM +0100, Benny Amorsen wrote:
>> Ric Wheeler <ric@emc.com> writes:
>>
>>> The only really safe default is to disable the write cache by default
>>> or possibly dynamically disable the write cache when barriers are not
>>> supported by a drive. Both have a severe performance impact and I am
>>> not sure that for most casual users it is a good trade.
>> So people ARE running their disks in a mode similar to Ramback.
> 
> Similar, but not as aggressive.  Remember, the size of the write cache
> on the hard drive is relatively small (small number of megabytes), and
> the drive generally is relatively aggressive about getting the data
> out to the platters; it's probably not going to keep unwritten data on
> the platters for minutes or hours at a time, let alone days.  Of
> course, unless you use write barriers or some kind of explicit write
> ordering, it's going to write stuff out in an order which is
> convenient to the hard drive, not necessarily an order convenient to
> the filesystem.

You get 8-16MB per disk with most drives today. Different firmware will 
do different things about how aggressively they push the data out to 
platter.

> Also, if the system crashes, you don't lose the data in hard drive's
> write cache, where as the data in Ramback is likely gone.  And Ramback
> is apaprently keeping potentially several gigabytes dirty in memory
> and *not* writing it out very aggressively.  So the exposure is one of
> degree.
> 
> In practice, it's interesting that we've had so few people reporting
> massive data loss despite the lack of the use of write barriers.
> Sure, in absolutely critical situations, it's not a good thing; but if
> I had a mail server, where I really wanted to make sure I didn't lose
> any e-mail, having a small UPS which could keep the server going for
> just a few minutes so it could do a controlled shutdown on a power
> failure is probably a better engineering solution from a
> cost/benefit/performance point of view, compared to turning on write
> barriers and taking up to two orders of magnitude worth of performance
> hit.
> 
> 						- Ted

Most people don't see power outages too often - maybe once a year? When 
you travel with a laptop, we are always effectively on a UPS so that 
will also tend to mask this issue.

The ingest rate at the time of a power hit makes a huge difference as 
well - basically, pulling the power cord when a box is idle is normally 
not harmful. Try that when you are really pounding on the disks and you 
will see corruptions a plenty without barriers ;-)

One note - the barrier hit for apps that use fsync() is just half an 
order of magnitude (say 35 files/sec instead of 120 files/sec). If you 
don't fsync() each file, the impact is lower still.

Still expensive, but might be reasonable for home users on a box with 
family photos, etc.

ric

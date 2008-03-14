Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbYCNRF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbYCNRF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 13:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYCNRFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 13:05:16 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:36003 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYCNRFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 13:05:15 -0400
Message-ID: <47DAB027.3070305@emc.com>
Date: Fri, 14 Mar 2008 13:04:39 -0400
From: Ric Wheeler <ric@emc.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <ric@emc.com>,
       Benny Amorsen <benny+usenet@amorsen.dk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803110450.19390.phillips@phunq.net> <20080311215601.GM23784@marowsky-bree.de> <200803111602.53835.phillips@phunq.net> <m3d4q08477.fsf@ursa.amorsen.dk> <20080312133001.1668f40d@the-village.bc.nu> <20080314093019.GA5966@ucw.cz> <47DA5C8D.2020207@emc.com> <m3fxutcz2s.fsf@ursa.amorsen.dk> <20080314125656.GA7412@mit.edu> <47DA9DF8.5010600@emc.com> <20080314164952.GA7767@mit.edu>
In-Reply-To: <20080314164952.GA7767@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.53115
X-PerlMx-Spam: Gauge=, SPAM=0%, Reason='EMC_BODY_PROD_1+ -3, EMC_BODY_PROD_2+ -3, EMC_FROM_0+ -3, __CP_MEDIA_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Fri, Mar 14, 2008 at 11:47:04AM -0400, Ric Wheeler wrote:
>> The ingest rate at the time of a power hit makes a huge difference as well 
>> - basically, pulling the power cord when a box is idle is normally not 
>> harmful. Try that when you are really pounding on the disks and you will 
>> see corruptions a plenty without barriers ;-)
> 
> Oh, no question.  But the fact that it mostly works when the box is
> idle means the hard drive firmware is reasonably aggressive about
> pushing data from the write cache out to the platters when it can.
> 
>> One note - the barrier hit for apps that use fsync() is just half an order 
>> of magnitude (say 35 files/sec instead of 120 files/sec). If you don't 
>> fsync() each file, the impact is lower still.
>>
>> Still expensive, but might be reasonable for home users on a box with 
>> family photos, etc.
> 
> It depends on the workload, obviously.  I thought I remember someone
> on this thread talking about benchmark where they went from ~2000 to
> ~20 ops/sec once they added fsync().  I'm sure that was an extreme
> benchmarking workload that isn't at all representative of real-life
> usage, where you're usually do something else modifying the metadata
> of many tiny files over and over again.  :-)

I think those were the numbers comparing a ramdisk, s-ata drive and a 
clariion all doing barriers ;-)

I just reran some quick tests on a home box with a s-ata drive writing 
50k files single threaded:

barriers off &    fsync: 133 files/sec
barriers off & no fsync: 2306 files/sec
barriers on  & no fsync: 2312 files/sec
barriers on  &    fsync: 22   files/sec

So no slowdown without fsync & a 5x slowdown when you fsync every write.

Doing the fsync is the only way to make (mostly sure) that all data is 
on platter, but you can write the files in a batch and then go back and 
reopen/fsync/close all files afterwards.

That helps a lot:

barriers on & bulk fsync (in order written)      : 218 files/sec
barriers on & bulk fsync (reverse order written) : 340 files/sec

All of this was measured with my fs_mark tool (it is also on 
sourceforge) with variations of the following:

fs_mark -d /home/ric/test -n 10000 -D 20 -N 500

(-S 0 no fsync, -S 1 fsync per file as written, -S 2 bulk reverse order, 
-S 3 bulk in order).

> It's also the case that a home user's fileserver is generally
> quiscent, which is probably why we aren't hearing lots of stories
> about home NAS servers (which I bet probably don't enable write
> barriers) trashing vast amounts of user data.....
> 
> 						- Ted

A lot of NAS boxes and storage boxes in general disable all write cache 
on drives just to be safe. It would be interesting to benchmark the nfs 
server with and without barriers from a client ;-)

ric

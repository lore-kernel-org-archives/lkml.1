Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbYFYTab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbYFYTab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYFYTaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:30:17 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:12374 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYFYTaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:30:15 -0400
Message-ID: <48629CB5.4070509@hp.com>
Date: Wed, 25 Jun 2008 15:29:57 -0400
From: Mark Seger <Mark.Seger@hp.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Inconsistencies in the way process memory is being reported in /proc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have seen past postings on this topic and there still seems to be 
issues.  Since adding process i/o stats to collectl I've been looking 
more closely at process stats in general and have been digging deeper 
into how memory is being accounted for on my current test system which 
is running a 2.6.23 kernel on top of a rhel4.2 distribution and have 
been using 'man proc' as a guide.

Specifically, I realize stats are reported in /proc/pid/stat, 
/proc/pid/statm and /proc/pid/status and according to the manpage 
'status' is mainly a summary of many of the data from the other 2 in 
more human readable form.  That said I wrote a little script that grabs 
all these structures as once and reports them in a way that lets me 
compare them all along with 'ps' outptu and when I do this I start 
getting dizzy.  For example, when I do a ps I see:

USER       PID %CPU %MEM   VSZ  RSS TTY      STAT START   TIME COMMAND
root     29216  0.0  0.3 81836 15160 ?       Ss   11:11   0:09 
/usr/bin/perl -w /usr/sbin/collectl -D

statm contains, after multiplying by 4 since these are in pages:
total:       81836
resident:    15160
sharedpages: 1280
text:        16
data/stack:  0
library:     14292
dirty:       0

and status contains:
VmPeak:    81836 kB
VmSize:    81836 kB
VmLck:         0 kB
VmHWM:     15160 kB
VmRSS:     15160 kB
VmData:    14208 kB
VmStk:        84 kB
VmExe:        16 kB
VmLib:      3620 kB
VmPTE:       108 kB

I only saw VSS and RSS in stat and happily they agree with all the other 
2 structures as well as ps

However, that's where the good news stops.  For example, statm says the 
data/stack size is 0 but status shows them as non-zero.  Furthermore, it 
looks like if I add the data and stacksize from 'status' I get the 
'library' size in statm.  The library size in 'status' is 3260 and I 
don't see any way to correlate that with anything!  I also don't see 
mention of some of the other fields reorted in 'status'.  I'm guessing 
peak/hwm are both highwater marks for vss and rss, but what about 
VmLck?  Can that be derived from anything in 'stat'?  I'm also assuming 
the size of the exe is constant and probably not particularly useful.

Can anyone shed any light on what numbers to believe or should I only 
count on vss/rss being correct?  If someone can provide more detailed 
definitions I'll be happy to add them to collectl's documentation.

And speaking of collectl, when it run as a daemon it continuously 
records all these files (and I'm hoping I can stop grabbing 'status' if 
someone can tell me how to derive these numbers from the other 2 data 
structures in a believable form) and a number of ways to later display 
the data.  In one form, it simply reports a bunch of fields from 
'status' as shown below:

# PID  User     S VmSize  VmLck  VmRSS VmData  VmStk  VmExe  VmLib MajF 
MinF Command
 3203  root     S 19940K      0   436K   416K    84K    48K  3800K    
0    0 rpc.idmapd
 3291  root     S  2876K      0   360K   240K    84K   208K  1276K    
0    0 /usr/sbin/smartd
 3395  root     S 22016K      0  1284K   444K    84K   324K  3496K    
0    0 /usr/sbin/sshd
 3410  root     S  8792K      0   792K   376K    84K   152K  1972K    
0    0 xinetd
 3420  root     S  4260K      0   336K   188K    84K    84K  1808K    
0    0 gpm
 3435  root     S 57132K      0   968K   436K   520K    40K  1492K    
0    0 crond

but I also admit these aren't necessarily the most useful fields to 
report, especially now that I've been digging deeper.  So my second 
question is if anyone cares to recommend some alternative fields to 
report under the category of 'process memory utilitization', I'd be 
happy to consider changing what I'm reporting.  Of course all that 
assume there is something more interesting than just vss and rss which 
I'm sure there must be.


sorry for being so long winded...
-mark


Return-Path: <linux-kernel-owner+w=401wt.eu-S1765678AbXG2RcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765678AbXG2RcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 13:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763837AbXG2Rbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 13:31:50 -0400
Received: from mail-1.netbauds.net ([62.232.161.102]:60729 "EHLO
	mail-1.netbauds.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759298AbXG2Rbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 13:31:48 -0400
Message-ID: <46ACCEEB.2070500@netbauds.net>
Date: Sun, 29 Jul 2007 18:31:23 +0100
From: "Darryl L. Miles" <darryl-mailinglists@netbauds.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.0.8) Gecko/20061109 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: TCP SACK issue, hung connection, tcpdump included
Content-Type: multipart/mixed;
 boundary="------------060102030904090003040404"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060102030904090003040404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


This is a reproducible problem (would take me between 30 mins and a day 
to reproduce it).  Please feel free to provide me with tcpdump options 
to be sure I include to get the information you need.

I've been informed there is no firewall at all, the only firewalling 
that takes place is the local Linux netfilter, I've never audited the 
kit at the SERVER end to know for sure.


I have run a tcpdump from the server side before now (not for the 
tcpdump I enclosed) when try to diagnose the problem in the first place 
and the triplet of packets:

09:28:11.331256 IP SERVER.ssh > CLIENT.50727: . 12408:13856(1448) ack 2991 win 2728 <nop,nop,timestamp 8084763 800001749>
09:28:11.331354 IP CLIENT.50727 > SERVER.ssh: . ack 18464 win 378 <nop,nop,timestamp 800099704 7692910,nop,nop,sack sack 1 {12408:13856} >
09:28:44.286495 IP CLIENT.50727 > SERVER.ssh: P 2991:3039(48) ack 18464 win 378 <nop,nop,timestamp 800107942 7692910>

That keeps repeating from that point in was observable at both sides.  
No checksum errors have ever been shown on any tcpdump I saw.


The dump I posted was the first dump I was able to reliably reproduce 
(observing from the CLIENT end), I'm pretty sure given some time 
tomorrow I could create you 2 dumps of the same session (the view from 
each end).   Looking a little more at the dump today I see that at time 
index 09:21:39.860245 to server sends data from seq 12408:13856 again.  
Here is a snippet that backs up a little more around the time the 
trouble starts, as SERVER send sequence 12408 seems to be the problem 
maybe I need to illustrate what happened when that sequence was first sent.

Excuse my understanding if it seems a bit limited.  SACK is only used 
when segments are dropped and from inspecting the dump I can't spot 
where a lost segment occurs.  My main question is why does the CLIENT 
ack data 12408:13856 and beyond all the way up to 18464 (@ 
09:21:39.490775) and then start to SACK {12408:13856} (@ 09:21:39.860302) ?

Does this mean the client is the buggy end for going back on data it has 
already acked cleanly, that would be my interpretation of events.


Enclosed should be a tcpdump with -vvS of the same session as before 
observing from the client side.

I hope I've answered all the points raised in this thread.

Darryl



--------------060102030904090003040404
Content-Type: text/plain;
 name="linux.tcpdump.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux.tcpdump.txt"

09:12:13.444999 IP (tos 0x0, ttl  64, id 56883, offset 0, flags [DF], proto 6, length: 60) CLIENT.50727 > SERVER.ssh: S [tcp sum ok] 2919512080:2919512080(0) win 5840 <mss 1460,sackOK,timestamp 799860259 0,nop,wscale 7>
09:12:13.535643 IP (tos 0x0, ttl  50, id 0, offset 0, flags [DF], proto 6, length: 60) SERVER.ssh > CLIENT.50727: S [tcp sum ok] 492909547:492909547(0) ack 2919512081 win 5792 <mss 1460,sackOK,timestamp 7126976 799860259,nop,wscale 2>
09:12:13.535717 IP (tos 0x0, ttl  64, id 56884, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919512081:2919512081(0) ack 492909548 win 46 <nop,nop,timestamp 799860282 7126976>
09:12:13.665481 IP (tos 0x0, ttl  50, id 62454, offset 0, flags [DF], proto 6, length: 75) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492909548:492909571(23) ack 2919512081 win 1448 <nop,nop,timestamp 7127074 799860282>
09:12:13.665895 IP (tos 0x0, ttl  64, id 56885, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919512081:2919512081(0) ack 492909571 win 46 <nop,nop,timestamp 799860314 7127074>
09:12:13.666044 IP (tos 0x0, ttl  64, id 56886, offset 0, flags [DF], proto 6, length: 74) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919512081:2919512103(22) ack 492909571 win 46 <nop,nop,timestamp 799860314 7127074>
09:12:13.776318 IP (tos 0x0, ttl  50, id 62456, offset 0, flags [DF], proto 6, length: 52) SERVER.ssh > CLIENT.50727: . [tcp sum ok] 492909571:492909571(0) ack 2919512103 win 1448 <nop,nop,timestamp 7127216 799860314>
09:12:13.776438 IP (tos 0x0, ttl  64, id 56887, offset 0, flags [DF], proto 6, length: 692) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919512103:2919512743(640) ack 492909571 win 46 <nop,nop,timestamp 799860342 7127216>
09:12:13.780319 IP (tos 0x0, ttl  50, id 62458, offset 0, flags [DF], proto 6, length: 692) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492909571:492910211(640) ack 2919512103 win 1448 <nop,nop,timestamp 7127218 799860314>
09:12:13.823098 IP (tos 0x0, ttl  64, id 56888, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919512743:2919512743(0) ack 492910211 win 56 <nop,nop,timestamp 799860353 7127218>
09:12:13.927103 IP (tos 0x0, ttl  50, id 62460, offset 0, flags [DF], proto 6, length: 52) SERVER.ssh > CLIENT.50727: . [tcp sum ok] 492910211:492910211(0) ack 2919512743 win 1768 <nop,nop,timestamp 7127367 799860342>
09:12:13.927174 IP (tos 0x0, ttl  64, id 56889, offset 0, flags [DF], proto 6, length: 76) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919512743:2919512767(24) ack 492910211 win 56 <nop,nop,timestamp 799860379 7127367>
09:12:14.016977 IP (tos 0x0, ttl  50, id 62462, offset 0, flags [DF], proto 6, length: 52) SERVER.ssh > CLIENT.50727: . [tcp sum ok] 492910211:492910211(0) ack 2919512767 win 1768 <nop,nop,timestamp 7127457 799860379>
09:12:14.019975 IP (tos 0x0, ttl  50, id 62464, offset 0, flags [DF], proto 6, length: 204) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492910211:492910363(152) ack 2919512767 win 1768 <nop,nop,timestamp 7127460 799860379>
09:12:14.020010 IP (tos 0x0, ttl  64, id 56890, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919512767:2919512767(0) ack 492910363 win 66 <nop,nop,timestamp 799860403 7127460>
09:12:14.024613 IP (tos 0x0, ttl  64, id 56891, offset 0, flags [DF], proto 6, length: 196) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919512767:2919512911(144) ack 492910363 win 66 <nop,nop,timestamp 799860404 7127460>
09:12:14.130830 IP (tos 0x0, ttl  50, id 62466, offset 0, flags [DF], proto 6, length: 516) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492910363:492910827(464) ack 2919512911 win 2088 <nop,nop,timestamp 7127569 799860404>
09:12:14.137330 IP (tos 0x0, ttl  64, id 56892, offset 0, flags [DF], proto 6, length: 68) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919512911:2919512927(16) ack 492910827 win 76 <nop,nop,timestamp 799860432 7127569>
09:12:14.267637 IP (tos 0x0, ttl  50, id 62468, offset 0, flags [DF], proto 6, length: 52) SERVER.ssh > CLIENT.50727: . [tcp sum ok] 492910827:492910827(0) ack 2919512927 win 2088 <nop,nop,timestamp 7127708 799860432>
09:12:14.267694 IP (tos 0x0, ttl  64, id 56893, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919512927:2919512975(48) ack 492910827 win 76 <nop,nop,timestamp 799860465 7127708>
09:12:14.360511 IP (tos 0x0, ttl  50, id 62470, offset 0, flags [DF], proto 6, length: 52) SERVER.ssh > CLIENT.50727: . [tcp sum ok] 492910827:492910827(0) ack 2919512975 win 2088 <nop,nop,timestamp 7127800 799860465>
09:12:14.360519 IP (tos 0x0, ttl  50, id 62472, offset 0, flags [DF], proto 6, length: 100) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492910827:492910875(48) ack 2919512975 win 2088 <nop,nop,timestamp 7127801 799860465>
09:12:14.362148 IP (tos 0x0, ttl  64, id 56894, offset 0, flags [DF], proto 6, length: 116) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919512975:2919513039(64) ack 492910875 win 76 <nop,nop,timestamp 799860488 7127801>
09:12:14.454385 IP (tos 0x0, ttl  50, id 62474, offset 0, flags [DF], proto 6, length: 132) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492910875:492910955(80) ack 2919513039 win 2088 <nop,nop,timestamp 7127895 799860488>
09:12:14.456614 IP (tos 0x0, ttl  64, id 56895, offset 0, flags [DF], proto 6, length: 148) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919513039:2919513135(96) ack 492910955 win 76 <nop,nop,timestamp 799860512 7127895>
09:12:14.554241 IP (tos 0x0, ttl  50, id 62476, offset 0, flags [DF], proto 6, length: 132) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492910955:492911035(80) ack 2919513135 win 2088 <nop,nop,timestamp 7127994 799860512>
09:12:14.555478 IP (tos 0x0, ttl  64, id 56896, offset 0, flags [DF], proto 6, length: 148) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919513135:2919513231(96) ack 492911035 win 76 <nop,nop,timestamp 799860536 7127994>
09:12:14.649117 IP (tos 0x0, ttl  50, id 62478, offset 0, flags [DF], proto 6, length: 132) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911035:492911115(80) ack 2919513231 win 2088 <nop,nop,timestamp 7128089 799860536>
09:12:14.649329 IP (tos 0x0, ttl  64, id 56897, offset 0, flags [DF], proto 6, length: 292) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919513231:2919513471(240) ack 492911115 win 76 <nop,nop,timestamp 799860560 7128089>
09:12:14.748977 IP (tos 0x0, ttl  50, id 62480, offset 0, flags [DF], proto 6, length: 244) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911115:492911307(192) ack 2919513471 win 2088 <nop,nop,timestamp 7128188 799860560>
09:12:14.751894 IP (tos 0x0, ttl  64, id 56898, offset 0, flags [DF], proto 6, length: 436) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919513471:2919513855(384) ack 492911307 win 86 <nop,nop,timestamp 799860586 7128188>
09:12:14.856839 IP (tos 0x0, ttl  50, id 62482, offset 0, flags [DF], proto 6, length: 84) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911307:492911339(32) ack 2919513855 win 2408 <nop,nop,timestamp 7128297 799860586>
09:12:14.857277 IP (tos 0x0, ttl  64, id 56899, offset 0, flags [DF], proto 6, length: 116) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919513855:2919513919(64) ack 492911339 win 86 <nop,nop,timestamp 799860612 7128297>
09:12:14.949708 IP (tos 0x0, ttl  50, id 62484, offset 0, flags [DF], proto 6, length: 100) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911339:492911387(48) ack 2919513919 win 2408 <nop,nop,timestamp 7128389 799860612>
09:12:14.950029 IP (tos 0x10, ttl  64, id 56900, offset 0, flags [DF], proto 6, length: 436) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919513919:2919514303(384) ack 492911387 win 86 <nop,nop,timestamp 799860635 7128389>
09:12:15.055558 IP (tos 0x0, ttl  50, id 62486, offset 0, flags [DF], proto 6, length: 100) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911387:492911435(48) ack 2919514303 win 2728 <nop,nop,timestamp 7128495 799860635>
09:12:15.095129 IP (tos 0x10, ttl  64, id 56901, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514303:2919514303(0) ack 492911435 win 86 <nop,nop,timestamp 799860671 7128495>
09:12:15.463999 IP (tos 0x0, ttl  50, id 62488, offset 0, flags [DF], proto 6, length: 180) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911435:492911563(128) ack 2919514303 win 2728 <nop,nop,timestamp 7128904 799860671>
09:12:15.464049 IP (tos 0x10, ttl  64, id 56902, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514303:2919514303(0) ack 492911563 win 96 <nop,nop,timestamp 799860764 7128904>
09:12:15.512928 IP (tos 0x0, ttl  50, id 62490, offset 0, flags [DF], proto 6, length: 116) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911563:492911627(64) ack 2919514303 win 2728 <nop,nop,timestamp 7128953 799860671>
09:12:15.512970 IP (tos 0x10, ttl  64, id 56903, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514303:2919514303(0) ack 492911627 win 96 <nop,nop,timestamp 799860776 7128953>
09:12:15.554874 IP (tos 0x0, ttl  50, id 62492, offset 0, flags [DF], proto 6, length: 132) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911627:492911707(80) ack 2919514303 win 2728 <nop,nop,timestamp 7128995 799860764>
09:12:15.554924 IP (tos 0x10, ttl  64, id 56904, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514303:2919514303(0) ack 492911707 win 96 <nop,nop,timestamp 799860786 7128995>
09:12:17.241429 IP (tos 0x10, ttl  64, id 56905, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514303:2919514351(48) ack 492911707 win 96 <nop,nop,timestamp 799861208 7128995>
09:12:17.333440 IP (tos 0x0, ttl  50, id 62494, offset 0, flags [DF], proto 6, length: 100) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911707:492911755(48) ack 2919514351 win 2728 <nop,nop,timestamp 7130773 799861208>
09:12:17.333494 IP (tos 0x10, ttl  64, id 56906, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514351:2919514351(0) ack 492911755 win 96 <nop,nop,timestamp 799861231 7130773>
09:12:17.413945 IP (tos 0x10, ttl  64, id 56907, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514351:2919514399(48) ack 492911755 win 96 <nop,nop,timestamp 799861251 7130773>
09:12:17.451470 IP (tos 0x10, ttl  64, id 56908, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514399:2919514447(48) ack 492911755 win 96 <nop,nop,timestamp 799861260 7130773>
09:12:17.506205 IP (tos 0x0, ttl  50, id 62496, offset 0, flags [DF], proto 6, length: 100) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911755:492911803(48) ack 2919514399 win 2728 <nop,nop,timestamp 7130947 799861251>
09:12:17.506256 IP (tos 0x10, ttl  64, id 56909, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514447:2919514447(0) ack 492911803 win 96 <nop,nop,timestamp 799861274 7130947>
09:12:17.529044 IP (tos 0x10, ttl  64, id 56910, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514447:2919514495(48) ack 492911803 win 96 <nop,nop,timestamp 799861280 7130947>
09:12:17.544148 IP (tos 0x0, ttl  50, id 62498, offset 0, flags [DF], proto 6, length: 100) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911803:492911851(48) ack 2919514447 win 2728 <nop,nop,timestamp 7130984 799861260>
09:12:17.587209 IP (tos 0x10, ttl  64, id 56911, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514495:2919514495(0) ack 492911851 win 96 <nop,nop,timestamp 799861294 7130984>
09:12:17.622042 IP (tos 0x0, ttl  50, id 62500, offset 0, flags [DF], proto 6, length: 100) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911851:492911899(48) ack 2919514495 win 2728 <nop,nop,timestamp 7131062 799861280>
09:12:17.622079 IP (tos 0x10, ttl  64, id 56912, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514495:2919514495(0) ack 492911899 win 96 <nop,nop,timestamp 799861303 7131062>
09:12:17.694314 IP (tos 0x10, ttl  64, id 56913, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514495:2919514543(48) ack 492911899 win 96 <nop,nop,timestamp 799861321 7131062>
09:12:17.756916 IP (tos 0x10, ttl  64, id 56914, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514543:2919514591(48) ack 492911899 win 96 <nop,nop,timestamp 799861337 7131062>
09:12:17.786827 IP (tos 0x0, ttl  50, id 62502, offset 0, flags [DF], proto 6, length: 100) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911899:492911947(48) ack 2919514543 win 2728 <nop,nop,timestamp 7131227 799861321>
09:12:17.786976 IP (tos 0x10, ttl  64, id 56915, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514591:2919514591(0) ack 492911947 win 96 <nop,nop,timestamp 799861344 7131227>
09:12:17.799913 IP (tos 0x10, ttl  64, id 56916, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514591:2919514639(48) ack 492911947 win 96 <nop,nop,timestamp 799861347 7131227>
09:12:17.849734 IP (tos 0x0, ttl  50, id 62504, offset 0, flags [DF], proto 6, length: 100) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911947:492911995(48) ack 2919514591 win 2728 <nop,nop,timestamp 7131290 799861337>
09:12:17.891225 IP (tos 0x10, ttl  64, id 56917, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514639:2919514639(0) ack 492911995 win 96 <nop,nop,timestamp 799861370 7131290>
09:12:17.892674 IP (tos 0x0, ttl  50, id 62506, offset 0, flags [DF], proto 6, length: 100) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492911995:492912043(48) ack 2919514639 win 2728 <nop,nop,timestamp 7131332 799861347>
09:12:17.892737 IP (tos 0x10, ttl  64, id 56918, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514639:2919514639(0) ack 492912043 win 96 <nop,nop,timestamp 799861371 7131332>
09:12:17.894672 IP (tos 0x0, ttl  50, id 62508, offset 0, flags [DF], proto 6, length: 164) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492912043:492912155(112) ack 2919514639 win 2728 <nop,nop,timestamp 7131334 799861347>
09:12:17.894743 IP (tos 0x10, ttl  64, id 56919, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514639:2919514639(0) ack 492912155 win 96 <nop,nop,timestamp 799861371 7131334>
09:12:17.982558 IP (tos 0x0, ttl  50, id 62510, offset 0, flags [DF], proto 6, length: 196) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492912155:492912299(144) ack 2919514639 win 2728 <nop,nop,timestamp 7131422 799861370>
09:12:17.982614 IP (tos 0x10, ttl  64, id 56920, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514639:2919514639(0) ack 492912299 win 106 <nop,nop,timestamp 799861393 7131422>
09:14:17.167894 IP (tos 0x10, ttl  64, id 56921, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514639:2919514687(48) ack 492912299 win 106 <nop,nop,timestamp 799891186 7131422>
09:14:17.261238 IP (tos 0x0, ttl  50, id 62512, offset 0, flags [DF], proto 6, length: 100) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492912299:492912347(48) ack 2919514687 win 2728 <nop,nop,timestamp 7250700 799891186>
09:14:17.261317 IP (tos 0x10, ttl  64, id 56922, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514687:2919514687(0) ack 492912347 win 106 <nop,nop,timestamp 799891210 7250700>
09:14:17.500671 IP (tos 0x10, ttl  64, id 56923, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514687:2919514735(48) ack 492912347 win 106 <nop,nop,timestamp 799891269 7250700>
09:14:17.592778 IP (tos 0x0, ttl  50, id 62514, offset 0, flags [DF], proto 6, length: 100) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492912347:492912395(48) ack 2919514735 win 2728 <nop,nop,timestamp 7251033 799891269>
09:14:17.592821 IP (tos 0x10, ttl  64, id 56924, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514735:2919514735(0) ack 492912395 win 106 <nop,nop,timestamp 799891292 7251033>
09:14:17.913715 IP (tos 0x10, ttl  64, id 56925, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514735:2919514783(48) ack 492912395 win 106 <nop,nop,timestamp 799891373 7251033>
09:14:18.006215 IP (tos 0x0, ttl  50, id 62516, offset 0, flags [DF], proto 6, length: 148) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492912395:492912491(96) ack 2919514783 win 2728 <nop,nop,timestamp 7251446 799891373>
09:14:18.006262 IP (tos 0x10, ttl  64, id 56926, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514783:2919514783(0) ack 492912491 win 106 <nop,nop,timestamp 799891396 7251446>
09:14:18.106615 IP (tos 0x10, ttl  64, id 56927, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514783:2919514831(48) ack 492912491 win 106 <nop,nop,timestamp 799891421 7251446>
09:14:18.146506 IP (tos 0x10, ttl  64, id 56928, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514831:2919514879(48) ack 492912491 win 106 <nop,nop,timestamp 799891431 7251446>
09:14:18.198965 IP (tos 0x0, ttl  50, id 62518, offset 0, flags [DF], proto 6, length: 116) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492912491:492912555(64) ack 2919514831 win 2728 <nop,nop,timestamp 7251638 799891421>
09:14:18.199102 IP (tos 0x10, ttl  64, id 56929, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514879:2919514879(0) ack 492912555 win 106 <nop,nop,timestamp 799891444 7251638>
09:14:18.238897 IP (tos 0x0, ttl  50, id 62520, offset 0, flags [DF], proto 6, length: 148) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492912555:492912651(96) ack 2919514879 win 2728 <nop,nop,timestamp 7251678 799891431>
09:14:18.238936 IP (tos 0x10, ttl  64, id 56930, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514879:2919514879(0) ack 492912651 win 106 <nop,nop,timestamp 799891454 7251678>
09:14:18.253235 IP (tos 0x10, ttl  64, id 56931, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514879:2919514927(48) ack 492912651 win 106 <nop,nop,timestamp 799891458 7251678>
09:14:18.345749 IP (tos 0x0, ttl  50, id 62522, offset 0, flags [DF], proto 6, length: 132) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492912651:492912731(80) ack 2919514927 win 2728 <nop,nop,timestamp 7251786 799891458>
09:14:18.387524 IP (tos 0x10, ttl  64, id 56932, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514927:2919514927(0) ack 492912731 win 106 <nop,nop,timestamp 799891491 7251786>
09:14:18.712692 IP (tos 0x10, ttl  64, id 56933, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514927:2919514975(48) ack 492912731 win 106 <nop,nop,timestamp 799891572 7251786>
09:14:18.805120 IP (tos 0x0, ttl  50, id 62524, offset 0, flags [DF], proto 6, length: 164) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492912731:492912843(112) ack 2919514975 win 2728 <nop,nop,timestamp 7252245 799891572>
09:14:18.805177 IP (tos 0x10, ttl  64, id 56934, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514975:2919514975(0) ack 492912843 win 106 <nop,nop,timestamp 799891596 7252245>
09:14:18.813107 IP (tos 0x0, ttl  50, id 62526, offset 0, flags [DF], proto 6, length: 148) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492912843:492912939(96) ack 2919514975 win 2728 <nop,nop,timestamp 7252253 799891572>
09:14:18.813138 IP (tos 0x10, ttl  64, id 56935, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514975:2919514975(0) ack 492912939 win 106 <nop,nop,timestamp 799891598 7252253>
09:14:18.902004 IP (tos 0x0, ttl  50, id 62528, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492912939:492914387(1448) ack 2919514975 win 2728 <nop,nop,timestamp 7252336 799891596>
09:14:18.902036 IP (tos 0x10, ttl  64, id 56936, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514975:2919514975(0) ack 492914387 win 129 <nop,nop,timestamp 799891620 7252336>
09:14:18.907996 IP (tos 0x0, ttl  50, id 62530, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492914387:492915835(1448) ack 2919514975 win 2728 <nop,nop,timestamp 7252336 799891596>
09:14:18.908027 IP (tos 0x10, ttl  64, id 56937, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514975:2919514975(0) ack 492915835 win 151 <nop,nop,timestamp 799891621 7252336>
09:14:18.913988 IP (tos 0x0, ttl  50, id 62532, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492915835:492917283(1448) ack 2919514975 win 2728 <nop,nop,timestamp 7252343 799891598>
09:14:18.914031 IP (tos 0x10, ttl  64, id 56938, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514975:2919514975(0) ack 492917283 win 174 <nop,nop,timestamp 799891623 7252343>
09:14:18.919984 IP (tos 0x0, ttl  50, id 62534, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492917283:492918731(1448) ack 2919514975 win 2728 <nop,nop,timestamp 7252343 799891598>
09:14:18.920016 IP (tos 0x10, ttl  64, id 56939, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514975:2919514975(0) ack 492918731 win 197 <nop,nop,timestamp 799891624 7252343>
09:14:18.999899 IP (tos 0x0, ttl  50, id 62536, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492918731:492920179(1448) ack 2919514975 win 2728 <nop,nop,timestamp 7252433 799891620>
09:14:19.000023 IP (tos 0x10, ttl  64, id 56940, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514975:2919514975(0) ack 492920179 win 219 <nop,nop,timestamp 799891644 7252433>
09:14:18.999913 IP (tos 0x0, ttl  50, id 62538, offset 0, flags [DF], proto 6, length: 60) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492920179:492920187(8) ack 2919514975 win 2728 <nop,nop,timestamp 7252433 799891620>
09:14:19.000069 IP (tos 0x10, ttl  64, id 56941, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919514975:2919514975(0) ack 492920187 win 219 <nop,nop,timestamp 799891644 7252433>
09:21:38.811134 IP (tos 0x10, ttl  64, id 56942, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919514975:2919515023(48) ack 492920187 win 219 <nop,nop,timestamp 800001585 7252433>
09:21:38.903536 IP (tos 0x0, ttl  50, id 62540, offset 0, flags [DF], proto 6, length: 100) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492920187:492920235(48) ack 2919515023 win 2728 <nop,nop,timestamp 7692342 800001585>
09:21:38.903622 IP (tos 0x10, ttl  64, id 56943, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515023:2919515023(0) ack 492920235 win 219 <nop,nop,timestamp 800001608 7692342>
09:21:39.276350 IP (tos 0x10, ttl  64, id 56944, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515023:2919515071(48) ack 492920235 win 219 <nop,nop,timestamp 800001701 7692342>
09:21:39.368907 IP (tos 0x0, ttl  50, id 62542, offset 0, flags [DF], proto 6, length: 100) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492920235:492920283(48) ack 2919515071 win 2728 <nop,nop,timestamp 7692807 800001701>
09:21:39.368980 IP (tos 0x10, ttl  64, id 56945, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492920283 win 219 <nop,nop,timestamp 800001725 7692807>
09:21:39.377887 IP (tos 0x0, ttl  50, id 62544, offset 0, flags [DF], proto 6, length: 148) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492920283:492920379(96) ack 2919515071 win 2728 <nop,nop,timestamp 7692816 800001701>
09:21:39.377919 IP (tos 0x10, ttl  64, id 56946, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492920379 win 219 <nop,nop,timestamp 800001727 7692816>
09:21:39.378889 IP (tos 0x0, ttl  50, id 62546, offset 0, flags [DF], proto 6, length: 180) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492920379:492920507(128) ack 2919515071 win 2728 <nop,nop,timestamp 7692816 800001701>
09:21:39.378920 IP (tos 0x10, ttl  64, id 56947, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492920507 win 242 <nop,nop,timestamp 800001727 7692816>
09:21:39.465799 IP (tos 0x0, ttl  50, id 62548, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492920507:492921955(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7692898 800001725>
09:21:39.465869 IP (tos 0x10, ttl  64, id 56948, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492921955 win 264 <nop,nop,timestamp 800001749 7692898>
09:21:39.471778 IP (tos 0x0, ttl  50, id 62550, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7692898 800001725>
09:21:39.471825 IP (tos 0x10, ttl  64, id 56949, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492923403 win 287 <nop,nop,timestamp 800001750 7692898>
09:21:39.477768 IP (tos 0x0, ttl  50, id 62552, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492923403:492924851(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7692907 800001727>
09:21:39.477801 IP (tos 0x10, ttl  64, id 56950, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492924851 win 310 <nop,nop,timestamp 800001752 7692907>
09:21:39.483760 IP (tos 0x0, ttl  50, id 62554, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492924851:492926299(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7692907 800001727>
09:21:39.483793 IP (tos 0x10, ttl  64, id 56951, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492926299 win 332 <nop,nop,timestamp 800001753 7692907>
09:21:39.489756 IP (tos 0x0, ttl  50, id 62556, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492926299:492927747(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7692910 800001727>
09:21:39.489800 IP (tos 0x10, ttl  64, id 56952, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492927747 win 355 <nop,nop,timestamp 800001755 7692910>
09:21:39.490740 IP (tos 0x0, ttl  50, id 62558, offset 0, flags [DF], proto 6, length: 316) SERVER.ssh > CLIENT.50727: P [tcp sum ok] 492927747:492928011(264) ack 2919515071 win 2728 <nop,nop,timestamp 7692910 800001727>
09:21:39.490775 IP (tos 0x10, ttl  64, id 56953, offset 0, flags [DF], proto 6, length: 52) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492928011 win 378 <nop,nop,timestamp 800001755 7692910>
09:21:39.860245 IP (tos 0x0, ttl  50, id 62560, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7693293 800001749>
09:21:39.860302 IP (tos 0x10, ttl  64, id 56954, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492928011 win 378 <nop,nop,timestamp 800001847 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:21:40.453440 IP (tos 0x0, ttl  50, id 62562, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7693887 800001749>
09:21:40.453495 IP (tos 0x10, ttl  64, id 56955, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492928011 win 378 <nop,nop,timestamp 800001996 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:21:41.641821 IP (tos 0x0, ttl  50, id 62564, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7695075 800001749>
09:21:41.641938 IP (tos 0x10, ttl  64, id 56956, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492928011 win 378 <nop,nop,timestamp 800002293 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:21:44.017552 IP (tos 0x0, ttl  50, id 62566, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7697451 800001749>
09:21:44.017622 IP (tos 0x10, ttl  64, id 56957, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492928011 win 378 <nop,nop,timestamp 800002887 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:21:48.770051 IP (tos 0x0, ttl  50, id 62568, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7702203 800001749>
09:21:48.770099 IP (tos 0x10, ttl  64, id 56958, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492928011 win 378 <nop,nop,timestamp 800004075 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:21:58.274061 IP (tos 0x0, ttl  50, id 62570, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7711707 800001749>
09:21:58.274180 IP (tos 0x10, ttl  64, id 56959, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492928011 win 378 <nop,nop,timestamp 800006450 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:22:17.282035 IP (tos 0x0, ttl  50, id 62572, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7730715 800001749>
09:22:17.282153 IP (tos 0x10, ttl  64, id 56960, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492928011 win 378 <nop,nop,timestamp 800011202 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:22:55.298955 IP (tos 0x0, ttl  50, id 62574, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7768731 800001749>
09:22:55.299023 IP (tos 0x10, ttl  64, id 56961, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492928011 win 378 <nop,nop,timestamp 800020705 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:24:11.329853 IP (tos 0x0, ttl  50, id 62576, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7844763 800001749>
09:24:11.329923 IP (tos 0x10, ttl  64, id 56962, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492928011 win 378 <nop,nop,timestamp 800039711 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:26:11.331578 IP (tos 0x0, ttl  50, id 62578, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 7964763 800001749>
09:26:11.331699 IP (tos 0x10, ttl  64, id 56963, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515071:2919515071(0) ack 492928011 win 378 <nop,nop,timestamp 800069708 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:26:13.011885 IP (tos 0x10, ttl  64, id 56964, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800070128 7692910>
09:26:13.309032 IP (tos 0x10, ttl  64, id 56965, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800070202 7692910>
09:26:13.901048 IP (tos 0x10, ttl  64, id 56966, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800070350 7692910>
09:26:15.085103 IP (tos 0x10, ttl  64, id 56967, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800070646 7692910>
09:26:17.453195 IP (tos 0x10, ttl  64, id 56968, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800071238 7692910>
09:26:22.189378 IP (tos 0x10, ttl  64, id 56969, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800072422 7692910>
09:26:31.661696 IP (tos 0x10, ttl  64, id 56970, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800074790 7692910>
09:26:50.610374 IP (tos 0x10, ttl  64, id 56971, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800079526 7692910>
09:27:28.499729 IP (tos 0x10, ttl  64, id 56972, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800088998 7692910>
09:27:43.240418 IP (tos 0x0, ttl  63, id 0, offset 0, flags [DF], proto 1, length: 84) CLIENT > SERVER: icmp 64: echo request seq 0
09:27:43.339568 IP (tos 0x0, ttl  50, id 14266, offset 0, flags [none], proto 1, length: 84) SERVER > CLIENT: icmp 64: echo reply seq 0
09:27:44.245669 IP (tos 0x0, ttl  63, id 0, offset 0, flags [DF], proto 1, length: 84) CLIENT > SERVER: icmp 64: echo request seq 1
09:27:44.339196 IP (tos 0x0, ttl  50, id 14267, offset 0, flags [none], proto 1, length: 84) SERVER > CLIENT: icmp 64: echo reply seq 1
09:28:11.331256 IP (tos 0x0, ttl  50, id 62580, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 8084763 800001749>
09:28:11.331354 IP (tos 0x10, ttl  64, id 56973, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515119:2919515119(0) ack 492928011 win 378 <nop,nop,timestamp 800099704 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:28:44.286495 IP (tos 0x10, ttl  64, id 56974, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800107942 7692910>
09:30:11.330959 IP (tos 0x0, ttl  50, id 62582, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 8204763 800001749>
09:30:11.331074 IP (tos 0x10, ttl  64, id 56975, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515119:2919515119(0) ack 492928011 win 378 <nop,nop,timestamp 800129701 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:30:44.298756 IP (tos 0x10, ttl  64, id 56976, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800137942 7692910>
09:32:11.331661 IP (tos 0x0, ttl  50, id 62584, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 8324763 800001749>
09:32:11.331727 IP (tos 0x10, ttl  64, id 56977, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515119:2919515119(0) ack 492928011 win 378 <nop,nop,timestamp 800159698 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:32:44.311051 IP (tos 0x10, ttl  64, id 56978, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800167942 7692910>
09:34:11.332375 IP (tos 0x0, ttl  50, id 62586, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 8444763 800001749>
09:34:11.332447 IP (tos 0x10, ttl  64, id 56979, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515119:2919515119(0) ack 492928011 win 378 <nop,nop,timestamp 800189695 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:34:44.323298 IP (tos 0x10, ttl  64, id 56980, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800197942 7692910>
09:36:11.332073 IP (tos 0x0, ttl  50, id 62588, offset 0, flags [DF], proto 6, length: 1500) SERVER.ssh > CLIENT.50727: . 492921955:492923403(1448) ack 2919515071 win 2728 <nop,nop,timestamp 8564763 800001749>
09:36:11.332166 IP (tos 0x10, ttl  64, id 56981, offset 0, flags [DF], proto 6, length: 64) CLIENT.50727 > SERVER.ssh: . [tcp sum ok] 2919515119:2919515119(0) ack 492928011 win 378 <nop,nop,timestamp 800219692 7692910,nop,nop,sack sack 1 {492921955:492923403} >
09:36:44.335591 IP (tos 0x10, ttl  64, id 56982, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800227942 7692910>
09:38:44.351950 IP (tos 0x10, ttl  64, id 56983, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800257942 7692910>
09:40:44.368172 IP (tos 0x10, ttl  64, id 56984, offset 0, flags [DF], proto 6, length: 100) CLIENT.50727 > SERVER.ssh: P [tcp sum ok] 2919515071:2919515119(48) ack 492928011 win 378 <nop,nop,timestamp 800287943 7692910>
09:46:02.051649 IP (tos 0x0, ttl  63, id 0, offset 0, flags [DF], proto 1, length: 84) CLIENT > SERVER: icmp 64: echo request seq 0
09:46:02.149135 IP (tos 0x0, ttl  50, id 14877, offset 0, flags [none], proto 1, length: 84) SERVER > CLIENT: icmp 64: echo reply seq 0
09:46:03.056134 IP (tos 0x0, ttl  63, id 0, offset 0, flags [DF], proto 1, length: 84) CLIENT > SERVER: icmp 64: echo request seq 1
09:46:03.144778 IP (tos 0x0, ttl  50, id 14878, offset 0, flags [none], proto 1, length: 84) SERVER > CLIENT: icmp 64: echo reply seq 1

--------------060102030904090003040404--

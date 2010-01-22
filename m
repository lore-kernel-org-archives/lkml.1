Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711Ab0AVLWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab0AVLWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 06:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084Ab0AVLWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 06:22:35 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:60097 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab0AVLWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 06:22:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=RsAZt3+IRzAll49TuQykWbQQNAYP02rXXKFf5ErMWOkK8Dy8MtfnrrQBvb0zUyVXr7
         AjgfcxFweVU3978wt9xhoPy1aF6gDrpUfgdsS0RtAj/kgw4X0EGKfT8AePe0n4MWw9VC
         KbQGlVpT1ldZV2IhiOAsKSJg2y8qTfrw7qdRA=
From: Luca Zini <luca.zini@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: scheduler vs hardware? (was Re: another i7  (linux) bug?)
Date: Fri, 22 Jan 2010 12:22:28 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31-17-server; KDE/4.3.4; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, aagaande@gmail.com,
       rdelcueto@hotmail.com, mingo@elte.hu,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>
References: <201001211258.23499.luca.zini@gmail.com> <1264152314.12530.8.camel@marge.simson.net> <1264152860.4283.1442.camel@laptop>
In-Reply-To: <1264152860.4283.1442.camel@laptop>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_0pYWLCvpM6wPX73"
Message-Id: <201001221222.28516.luca.zini@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_0pYWLCvpM6wPX73
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

First of all sorry for misunderstanding with Alex Chiang, I was trying to 
collect some data from other i7 mobile users to try to isolate the problem 
before posting.

I tried different things: I disabled speedstep from the bios and the results 
where more sensible (higher priority lower execution time). The same thing 
happens if I disable throttling  by software selecting "aggressive powersave" 
settings.

So I suppose that is something related directly or indirectly to frequency 
scaling or turbo boost (unfortunately I have no bios option to disable only 
turbo boost) 
Here are the results of the same test of Peter Zijlstra

time  sudo nice -n 19 lame -b 256 -V0 -h youcantdothat.wav  2&> /dev/null

real    0m1.105s
user    0m1.090s
sys     0m0.010s

time  sudo nice -n 0 lame -b 256 -V0 -h youcantdothat.wav  2&> /dev/null

real    0m1.108s
user    0m1.100s
sys     0m0.010s

time  sudo nice -n -20 lame -b 256 -V0 -h youcantdothat.wav  2&> /dev/null

real    0m1.354s
user    0m1.330s
sys     0m0.000s

They are almost the same results that I obtained before.
Looking at top there are no other process that is using the cpu  (main are 
Xorg and kopete).

I tested this on  2.6.31-17-server (ubuntu 9.10) 2.6.31-17-generic (ubuntu 
9.10) and the default kernel of fedora 12 (live cd).
As soon as possible I'll try 33-rc5 as requested by Mike Galbraith (now I 
can't shut down the computer).

Ok, a last minute update! 
I slightly modified i7z to save a log to disk. If i7z output are reliable I 
suppose that it can show is the problem:
with nice set to 19 a processor 3 reach the maximum speed,  with nice set to 
-20 its maximum value is 300-400 mhz under the maximum value. (I attach the 
two logs named as the nice level used obtained running lame on a bigger file)
Please note that logs may have some value read before and/or after the 
start/end of the running process (lame).

The next update will be the results with 33-rc5 kernel.

Luca

--Boundary-00=_0pYWLCvpM6wPX73
Content-Type: text/plain;
  charset="UTF-8";
  name="log-20"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log-20"

	Processor 0:  1062.13 (7.99x)	   1	99.7	   0	98.5
	Processor 1:  1246.75 (9.37x)	   1	99.8	   0	  99
	Processor 2:  1113.41 (8.37x)	   1	99.8	   0	98.4
	Processor 3:  1477.30 (11.11x)	4.67	95.7	   0	85.7
	Processor 0:  1109.70 (8.34x)	   1	99.7	2.93	95.8
	Processor 1:  2316.51 (17.42x)	 5.5	  92	   0	91.7
	Processor 2:  1114.96 (8.38x)	   1	99.8	14.9	83.7
	Processor 3:  1225.48 (9.21x)	9.95	92.4	1.33	67.6
	Processor 0:  1877.15 (14.11x)	   1	99.8	29.6	69.9
	Processor 1:  1914.75 (14.40x)	   1	99.2	   1	98.1
	Processor 2:  1955.22 (14.70x)	   1	99.8	   0	99.4
	Processor 3:  2402.49 (18.06x)	38.8	41.6	   0	   0
	Processor 0:  2114.28 (15.90x)	  12	84.1	   0	35.4
	Processor 1:  1528.62 (11.49x)	   1	99.8	25.4	73.2
	Processor 2:  1582.10 (11.90x)	   1	99.9	74.2	25.2
	Processor 3:  2359.66 (17.74x)	14.6	78.3	18.6	  56
	Processor 0:  2242.78 (16.86x)	16.3	77.1	   0	   0
	Processor 1:  1591.62 (11.97x)	   1	99.9	87.9	10.9
	Processor 2:  1885.84 (14.18x)	   1	 100	99.2	   1
	Processor 3:  2035.81 (15.31x)	1.77	97.7	  15	75.4
	Processor 0:  2280.59 (17.15x)	18.3	73.8	   1	70.4
	Processor 1:  1906.72 (14.34x)	   1	99.7	26.9	  72
	Processor 2:  1778.56 (13.37x)	   1	99.9	70.9	28.6
	Processor 3:  1077.58 (8.10x)	8.56	94.2	3.66	4.79
	Processor 0:  2009.19 (15.11x)	7.07	91.1	   1	88.3
	Processor 1:  1708.96 (12.85x)	   1	99.8	37.3	61.5
	Processor 2:  1673.01 (12.58x)	   1	99.9	13.4	85.9
	Processor 3:  1421.09 (10.68x)	12.1	89.2	   1	21.8

--Boundary-00=_0pYWLCvpM6wPX73
Content-Type: text/plain;
  charset="UTF-8";
  name="log19"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log19"

	Processor 0:  935.30 (7.03x)	   1	99.8	   0	73.4
	Processor 1:  938.46 (7.06x)	   1	99.9	   0	98.3
	Processor 2:  932.33 (7.01x)	   1	99.9	   0	97.7
	Processor 3:  1017.69 (7.65x)	6.09	96.1	   0	92.1
	Processor 0:  1040.73 (7.83x)	   1	99.8	   0	99.1
	Processor 1:  1062.37 (7.99x)	   1	99.7	   0	96.1
	Processor 2:  1047.94 (7.88x)	   1	99.8	   1	97.7
	Processor 3:  1941.75 (14.60x)	11.1	86.5	2.98	81.5
	Processor 0:  1940.64 (14.59x)	   1	99.5	   0	72.7
	Processor 1:  1600.11 (12.03x)	   1	99.8	11.5	  86
	Processor 2:  2141.58 (16.10x)	   1	 100	99.6	   1
	Processor 3:  2760.11 (20.75x)	83.2	   0	4.33	11.6
	Processor 0:  2331.59 (17.53x)	   1	99.4	5.98	  93
	Processor 1:  2287.80 (17.20x)	   1	99.8	   0	97.6
	Processor 2:  2122.39 (15.96x)	   1	 100	88.5	11.1
	Processor 3:  2774.36 (20.86x)	99.9	   0	   0	   0
	Processor 0:  2322.64 (17.46x)	   1	99.5	   1	98.6
	Processor 1:  2275.29 (17.11x)	   1	99.8	   1	97.9
	Processor 2:  2268.43 (17.06x)	   1	99.8	   0	99.5
	Processor 3:  2779.36 (20.90x)	99.9	   0	   0	   0
	Processor 0:  2277.58 (17.12x)	   1	99.8	   0	99.6
	Processor 1:  2372.66 (17.84x)	   1	99.5	   0	99.2
	Processor 2:  2346.90 (17.65x)	   1	99.8	   0	99.5
	Processor 3:  2783.34 (20.93x)	99.9	   0	   0	   0

--Boundary-00=_0pYWLCvpM6wPX73--

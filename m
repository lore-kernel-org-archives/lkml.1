Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbXEJLxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbXEJLxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757872AbXEJLxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:53:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:48404 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbXEJLxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:53:15 -0400
Message-ID: <d95aa510705100453y666cf310ic9ee4dc609f099f1@mail.gmail.com>
Date: Thu, 10 May 2007 17:23:12 +0530
From: "Anant Nitya" <kernel@prachanda.info>
To: tglx@linutronix.de
Subject: Re: [BUG] local_softirq_pending storm
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1178728280.3042.504.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705091942.22920.kernel@prachanda.hub>
	 <1178728280.3042.504.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 2007-05-09 at 19:42 +0530, Anant Nitya wrote:
> > Hi,
> > Ever since I upgrade to 2.6.21/.1, system log is filled with following
> > messages if I enable CONFIG_NO_HZ=y, going through archives it seems ingo
> > sometime back posted some patch and now it is upstream, but its not helping
> > here. If I disable NOHZ by kernel command line nohz=off this problem
> > disappears. This system is P4/2.40GHz/HT with SMP/SMT on in kernel config.
> > One more thing that I noticed is this problem only arises while using X or
> > network otherwise plain command line with no network access don't trigger
> > this with nohz=on.
>
> Is this independent of the load on the system ? i.e. : What happens if
> you only use the console and run a kernel compile with -j4 ?
Yep, it seems independent of load on the system, to test I compiled
kernel with make -j8 and to throw some more load same time I also used
amavisd to clean around 2000 of spam/virus infected mails and same
time was listening to few radio stream over net in console only login
mode. Even then there was not a single NOHZ: local_softirq_pending
message in log. Once kernel got compiled and amavisd finished its job
and load drops back to around 0.5/2.0 I started X and within few secs
log starts getting filled with local_softirq_pending messages, (sorry,
I didn't applied ratelimit patch since I wanted to test is it high
load on system that causes this or something else). It seems even
network operation is not causing this. It seems either X is doing
something terribly wrong or kernel is getting hosed by X.
If some more information is needed please feel free to ask

dumdum@hahakaar [~]$ >> grep load top.log
top - 14:04:12 up 15 min,  4 users,  load average: 9.42, 5.12, 2.20
top - 14:04:17 up 15 min,  4 users,  load average: 9.47, 5.20, 2.24
top - 14:04:22 up 16 min,  4 users,  load average: 9.35, 5.25, 2.27
top - 14:04:27 up 16 min,  4 users,  load average: 9.32, 5.31, 2.31
top - 14:04:32 up 16 min,  4 users,  load average: 9.22, 5.36, 2.34
top - 14:04:37 up 16 min,  4 users,  load average: 9.36, 5.45, 2.38
top - 14:04:42 up 16 min,  4 users,  load average: 9.33, 5.51, 2.42
top - 14:04:47 up 16 min,  4 users,  load average: 9.38, 5.58, 2.46
top - 14:04:52 up 16 min,  4 users,  load average: 9.35, 5.64, 2.49
top - 14:04:57 up 16 min,  4 users,  load average: 9.24, 5.68, 2.52
top - 14:05:02 up 16 min,  4 users,  load average: 9.14, 5.72, 2.55
top - 14:05:07 up 16 min,  4 users,  load average: 9.05, 5.75, 2.58
top - 14:05:12 up 16 min,  4 users,  load average: 9.13, 5.83, 2.62
top - 14:05:17 up 16 min,  4 users,  load average: 9.28, 5.91, 2.66
top - 14:05:22 up 17 min,  4 users,  load average: 9.34, 5.98, 2.70
top - 14:05:27 up 17 min,  4 users,  load average: 9.47, 6.06, 2.75
top - 14:05:32 up 17 min,  4 users,  load average: 9.43, 6.11, 2.78
top - 14:05:37 up 17 min,  4 users,  load average: 9.32, 6.14, 2.81
top - 14:05:42 up 17 min,  4 users,  load average: 9.37, 6.20, 2.85
top - 14:05:47 up 17 min,  4 users,  load average: 9.26, 6.23, 2.87
top - 14:05:52 up 17 min,  4 users,  load average: 9.16, 6.26, 2.90
top - 14:05:58 up 17 min,  4 users,  load average: 9.07, 6.29, 2.93
top - 14:06:03 up 17 min,  4 users,  load average: 9.14, 6.35, 2.97
top - 14:06:08 up 17 min,  4 users,  load average: 9.13, 6.40, 3.00
top - 14:06:13 up 17 min,  4 users,  load average: 9.28, 6.47, 3.04
top - 14:06:18 up 17 min,  4 users,  load average: 9.34, 6.53, 3.08
top - 14:06:23 up 18 min,  4 users,  load average: 9.31, 6.57, 3.11
top - 14:06:28 up 18 min,  4 users,  load average: 9.36, 6.63, 3.15
top - 14:06:33 up 18 min,  4 users,  load average: 9.25, 6.65, 3.17
top - 14:06:38 up 18 min,  4 users,  load average: 9.23, 6.69, 3.20
top - 14:06:43 up 18 min,  4 users,  load average: 9.38, 6.76, 3.25
top - 14:06:48 up 18 min,  4 users,  load average: 9.27, 6.78, 3.27
top - 14:06:53 up 18 min,  4 users,  load average: 9.32, 6.84, 3.31
top - 14:06:58 up 18 min,  4 users,  load average: 9.70, 6.95, 3.36
top - 14:07:03 up 18 min,  4 users,  load average: 9.72, 7.00, 3.40
top - 14:07:08 up 18 min,  4 users,  load average: 9.82, 7.07, 3.44
top - 14:07:13 up 18 min,  4 users,  load average: 9.84, 7.12, 3.48
top - 14:07:18 up 18 min,  4 users,  load average: 9.85, 7.17, 3.51
top - 14:07:23 up 19 min,  4 users,  load average: 9.78, 7.20, 3.54
top - 14:07:28 up 19 min,  4 users,  load average: 9.80, 7.24, 3.57
top - 14:07:33 up 19 min,  4 users,  load average: 10.14, 7.40, 3.66
top - 14:07:38 up 19 min,  4 users,  load average: 10.45, 7.51, 3.72
top - 14:07:43 up 19 min,  4 users,  load average: 10.33, 7.53, 3.75
top - 14:07:48 up 19 min,  4 users,  load average: 9.58, 7.42, 3.73
top - 14:07:53 up 19 min,  4 users,  load average: 8.97, 7.33, 3.72
top - 14:07:58 up 19 min,  4 users,  load average: 8.34, 7.23, 3.71
top - 14:08:03 up 19 min,  4 users,  load average: 8.31, 7.24, 3.73
top - 14:08:08 up 19 min,  4 users,  load average: 8.36, 7.27, 3.76
top - 14:08:13 up 19 min,  4 users,  load average: 8.89, 7.40, 3.82
top - 14:08:18 up 20 min,  4 users,  load average: 8.34, 7.31, 3.81
top - 14:08:23 up 20 min,  4 users,  load average: 8.47, 7.35, 3.84
top - 14:08:28 up 20 min,  4 users,  load average: 8.52, 7.38, 3.87
top - 14:08:33 up 20 min,  4 users,  load average: 8.56, 7.41, 3.90
top - 14:08:39 up 20 min,  4 users,  load average: 8.51, 7.42, 3.92
top - 14:08:44 up 20 min,  4 users,  load average: 8.63, 7.46, 3.95
top - 14:08:49 up 20 min,  4 users,  load average: 8.66, 7.48, 3.98
top - 14:08:54 up 20 min,  4 users,  load average: 8.85, 7.54, 4.02
top - 14:08:59 up 20 min,  4 users,  load average: 8.94, 7.58, 4.05
top - 14:09:04 up 20 min,  4 users,  load average: 9.02, 7.62, 4.08
top - 14:09:09 up 20 min,  4 users,  load average: 9.02, 7.64, 4.10
top - 14:09:14 up 20 min,  4 users,  load average: 8.94, 7.65, 4.13
top - 14:09:19 up 21 min,  4 users,  load average: 9.02, 7.69, 4.16
top - 14:09:24 up 21 min,  4 users,  load average: 8.94, 7.69, 4.18
top - 14:09:29 up 21 min,  4 users,  load average: 8.87, 7.70, 4.20
top - 14:09:34 up 21 min,  4 users,  load average: 8.88, 7.72, 4.22
top - 14:09:39 up 21 min,  4 users,  load average: 8.81, 7.72, 4.24
top - 14:09:44 up 21 min,  4 users,  load average: 8.82, 7.75, 4.27
top - 14:09:49 up 21 min,  4 users,  load average: 8.76, 7.75, 4.29
top - 14:09:54 up 21 min,  4 users,  load average: 8.85, 7.79, 4.32
top - 14:09:59 up 21 min,  4 users,  load average: 8.79, 7.79, 4.34
top - 14:10:04 up 21 min,  4 users,  load average: 8.88, 7.83, 4.37
top - 14:10:09 up 21 min,  4 users,  load average: 8.81, 7.83, 4.39
top - 14:10:14 up 21 min,  5 users,  load average: 8.75, 7.83, 4.41
top - 14:10:19 up 22 min,  5 users,  load average: 8.77, 7.85, 4.43
top - 14:10:24 up 22 min,  5 users,  load average: 8.79, 7.87, 4.46
top - 14:10:29 up 22 min,  5 users,  load average: 8.72, 7.87, 4.47
top - 14:10:34 up 22 min,  5 users,  load average: 8.74, 7.89, 4.50
top - 14:10:39 up 22 min,  5 users,  load average: 8.92, 7.94, 4.53
top - 14:10:44 up 22 min,  5 users,  load average: 9.17, 8.01, 4.57
top - 14:10:49 up 22 min,  5 users,  load average: 9.24, 8.04, 4.60
top - 14:10:54 up 22 min,  5 users,  load average: 9.14, 8.04, 4.62
top - 14:10:59 up 22 min,  5 users,  load average: 9.21, 8.07, 4.65
top - 14:11:04 up 22 min,  5 users,  load average: 9.27, 8.10, 4.68
top - 14:11:09 up 22 min,  5 users,  load average: 9.25, 8.12, 4.70
top - 14:11:14 up 22 min,  5 users,  load average: 9.15, 8.12, 4.72
top - 14:11:19 up 23 min,  5 users,  load average: 9.06, 8.11, 4.73
top - 14:11:24 up 23 min,  5 users,  load average: 8.97, 8.11, 4.75
top - 14:11:29 up 23 min,  5 users,  load average: 9.13, 8.16, 4.79
top - 14:11:35 up 23 min,  5 users,  load average: 9.04, 8.16, 4.80
top - 14:11:40 up 23 min,  5 users,  load average: 9.12, 8.19, 4.83
top - 14:11:45 up 23 min,  5 users,  load average: 9.27, 8.23, 4.86
top - 14:11:50 up 23 min,  5 users,  load average: 9.33, 8.26, 4.89
top - 14:11:55 up 23 min,  5 users,  load average: 9.22, 8.26, 4.91
top - 14:12:00 up 23 min,  5 users,  load average: 9.28, 8.29, 4.93
top - 14:12:05 up 23 min,  5 users,  load average: 9.34, 8.32, 4.96
top - 14:12:10 up 23 min,  5 users,  load average: 9.47, 8.36, 4.99
top - 14:12:15 up 23 min,  5 users,  load average: 9.51, 8.39, 5.02
top - 14:12:20 up 24 min,  5 users,  load average: 9.47, 8.40, 5.04
top - 14:12:25 up 24 min,  5 users,  load average: 9.52, 8.42, 5.07
top - 14:12:30 up 24 min,  5 users,  load average: 9.47, 8.43, 5.09
top - 14:12:35 up 24 min,  5 users,  load average: 9.36, 8.43, 5.10
top - 14:12:40 up 24 min,  5 users,  load average: 9.25, 8.42, 5.12
top - 14:12:45 up 24 min,  5 users,  load average: 9.39, 8.46, 5.15
top - 14:12:50 up 24 min,  5 users,  load average: 9.36, 8.47, 5.17
top - 14:12:55 up 24 min,  5 users,  load average: 9.41, 8.50, 5.20
top - 14:13:00 up 24 min,  5 users,  load average: 9.45, 8.52, 5.22
top - 14:13:05 up 24 min,  5 users,  load average: 9.34, 8.51, 5.24
top - 14:13:10 up 24 min,  5 users,  load average: 9.23, 8.50, 5.25
top - 14:13:15 up 24 min,  5 users,  load average: 9.29, 8.53, 5.28
top - 14:13:20 up 25 min,  5 users,  load average: 9.35, 8.55, 5.30
top - 14:13:25 up 25 min,  5 users,  load average: 9.32, 8.56, 5.32
top - 14:13:30 up 25 min,  5 users,  load average: 9.21, 8.55, 5.34
top - 14:13:35 up 25 min,  5 users,  load average: 9.20, 8.56, 5.35
top - 14:13:40 up 25 min,  5 users,  load average: 9.10, 8.55, 5.37
top - 14:13:45 up 25 min,  5 users,  load average: 9.17, 8.57, 5.39
top - 14:13:50 up 25 min,  5 users,  load average: 9.08, 8.56, 5.41
top - 14:13:55 up 25 min,  5 users,  load average: 9.07, 8.57, 5.43
top - 14:14:00 up 25 min,  5 users,  load average: 8.99, 8.56, 5.44
top - 14:14:05 up 25 min,  5 users,  load average: 8.91, 8.55, 5.45
top - 14:14:10 up 25 min,  5 users,  load average: 8.91, 8.56, 5.47
top - 14:14:16 up 25 min,  5 users,  load average: 8.92, 8.56, 5.49
top - 14:14:21 up 26 min,  5 users,  load average: 8.85, 8.55, 5.50
top - 14:14:26 up 26 min,  5 users,  load average: 8.86, 8.56, 5.52
top - 14:14:31 up 26 min,  5 users,  load average: 9.03, 8.60, 5.55
top - 14:14:36 up 26 min,  5 users,  load average: 9.19, 8.64, 5.58
top - 14:14:41 up 26 min,  5 users,  load average: 9.17, 8.65, 5.60
top - 14:14:46 up 26 min,  5 users,  load average: 9.24, 8.67, 5.62
top - 14:14:51 up 26 min,  5 users,  load average: 9.22, 8.67, 5.64
top - 14:14:56 up 26 min,  5 users,  load average: 9.28, 8.70, 5.66
top - 14:15:01 up 26 min,  5 users,  load average: 9.26, 8.70, 5.68
top - 14:15:06 up 26 min,  5 users,  load average: 9.16, 8.69, 5.69
top - 14:15:11 up 26 min,  5 users,  load average: 9.14, 8.69, 5.71
top - 14:15:16 up 26 min,  5 users,  load average: 9.05, 8.68, 5.72
top - 14:15:21 up 27 min,  5 users,  load average: 9.13, 8.70, 5.75
top - 14:15:26 up 27 min,  5 users,  load average: 9.04, 8.69, 5.76
top - 14:15:31 up 27 min,  5 users,  load average: 9.11, 8.71, 5.78
top - 14:15:36 up 27 min,  5 users,  load average: 9.19, 8.74, 5.80
top - 14:15:41 up 27 min,  5 users,  load average: 9.17, 8.74, 5.82
top - 14:15:46 up 27 min,  5 users,  load average: 9.08, 8.73, 5.83
top - 14:15:51 up 27 min,  5 users,  load average: 8.99, 8.71, 5.84
top - 14:15:56 up 27 min,  5 users,  load average: 8.99, 8.72, 5.86
top - 14:16:01 up 27 min,  5 users,  load average: 8.99, 8.72, 5.88
top - 14:16:06 up 27 min,  5 users,  load average: 8.91, 8.71, 5.89
top - 14:16:11 up 27 min,  5 users,  load average: 8.92, 8.72, 5.90
top - 14:16:16 up 27 min,  5 users,  load average: 9.00, 8.74, 5.93
top - 14:16:21 up 28 min,  5 users,  load average: 9.00, 8.74, 5.94
top - 14:16:26 up 28 min,  5 users,  load average: 9.00, 8.74, 5.96
top - 14:16:31 up 28 min,  5 users,  load average: 9.00, 8.75, 5.97
top - 14:16:37 up 28 min,  5 users,  load average: 9.08, 8.77, 6.00
top - 14:16:42 up 28 min,  5 users,  load average: 9.16, 8.79, 6.02
top - 14:16:47 up 28 min,  5 users,  load average: 9.06, 8.78, 6.03
top - 14:16:52 up 28 min,  5 users,  load average: 8.98, 8.76, 6.04
top - 14:16:57 up 28 min,  5 users,  load average: 8.90, 8.75, 6.05
top - 14:17:02 up 28 min,  5 users,  load average: 9.15, 8.80, 6.08
top - 14:17:07 up 28 min,  5 users,  load average: 9.14, 8.81, 6.09
top - 14:17:12 up 28 min,  5 users,  load average: 9.12, 8.81, 6.11
top - 14:17:17 up 28 min,  5 users,  load average: 9.11, 8.81, 6.12
top - 14:17:22 up 29 min,  5 users,  load average: 9.02, 8.80, 6.13
top - 14:17:27 up 29 min,  5 users,  load average: 9.02, 8.80, 6.15
top - 14:17:32 up 29 min,  5 users,  load average: 9.02, 8.80, 6.16
top - 14:17:37 up 29 min,  5 users,  load average: 9.18, 8.84, 6.19
top - 14:17:42 up 29 min,  5 users,  load average: 9.24, 8.86, 6.21
top - 14:17:47 up 29 min,  5 users,  load average: 9.22, 8.86, 6.23
top - 14:17:52 up 29 min,  5 users,  load average: 9.21, 8.86, 6.24
top - 14:17:57 up 29 min,  5 users,  load average: 9.19, 8.87, 6.25
top - 14:18:02 up 29 min,  5 users,  load average: 9.33, 8.90, 6.28
top - 14:18:07 up 29 min,  5 users,  load average: 9.47, 8.93, 6.31
top - 14:18:12 up 29 min,  5 users,  load average: 9.43, 8.94, 6.32
top - 14:18:17 up 29 min,  5 users,  load average: 9.47, 8.95, 6.34
top - 14:18:22 up 30 min,  5 users,  load average: 9.52, 8.97, 6.36
top - 14:18:27 up 30 min,  5 users,  load average: 9.64, 9.00, 6.38
top - 14:18:32 up 30 min,  5 users,  load average: 9.58, 9.00, 6.40
top - 14:18:37 up 30 min,  5 users,  load average: 9.62, 9.02, 6.42
top - 14:18:42 up 30 min,  5 users,  load average: 9.65, 9.04, 6.43
top - 14:18:47 up 30 min,  5 users,  load average: 9.68, 9.05, 6.45
top - 14:18:52 up 30 min,  5 users,  load average: 9.86, 9.10, 6.48
top - 14:18:57 up 30 min,  5 users,  load average: 10.03, 9.15, 6.51
top - 14:19:02 up 30 min,  5 users,  load average: 10.11, 9.18, 6.54
top - 14:19:07 up 30 min,  5 users,  load average: 10.18, 9.21, 6.56
top - 14:19:12 up 30 min,  6 users,  load average: 10.25, 9.24, 6.58
top - 14:19:17 up 30 min,  6 users,  load average: 10.47, 9.30, 6.62
top - 14:19:22 up 31 min,  6 users,  load average: 10.51, 9.33, 6.64
top - 14:19:27 up 31 min,  6 users,  load average: 10.47, 9.34, 6.66
top - 14:19:32 up 31 min,  6 users,  load average: 10.59, 9.38, 6.69
top - 14:19:38 up 31 min,  6 users,  load average: 10.46, 9.38, 6.70
top - 14:19:43 up 31 min,  6 users,  load average: 10.59, 9.42, 6.73
top - 14:19:48 up 31 min,  6 users,  load average: 10.46, 9.41, 6.74
top - 14:19:53 up 31 min,  6 users,  load average: 10.34, 9.40, 6.75
top - 14:19:58 up 31 min,  6 users,  load average: 10.23, 9.40, 6.76
top - 14:20:03 up 31 min,  6 users,  load average: 10.29, 9.42, 6.79
top - 14:20:08 up 31 min,  6 users,  load average: 10.19, 9.42, 6.80
top - 14:20:13 up 31 min,  6 users,  load average: 10.26, 9.44, 6.82
top - 14:20:18 up 31 min,  6 users,  load average: 10.23, 9.45, 6.84
top - 14:20:23 up 32 min,  6 users,  load average: 10.14, 9.44, 6.85
top - 14:20:28 up 32 min,  6 users,  load average: 10.04, 9.44, 6.86
top - 14:20:33 up 32 min,  6 users,  load average: 9.96, 9.43, 6.87
top - 14:20:38 up 32 min,  6 users,  load average: 10.12, 9.47, 6.90
top - 14:20:43 up 32 min,  6 users,  load average: 10.11, 9.48, 6.91
top - 14:20:48 up 32 min,  6 users,  load average: 10.10, 9.49, 6.93
top - 14:20:53 up 32 min,  6 users,  load average: 10.18, 9.51, 6.95
top - 14:20:58 up 32 min,  6 users,  load average: 10.08, 9.50, 6.96
top - 14:21:03 up 32 min,  6 users,  load average: 9.99, 9.50, 6.97
top - 14:21:08 up 32 min,  6 users,  load average: 10.07, 9.52, 7.00
top - 14:21:13 up 32 min,  6 users,  load average: 9.99, 9.51, 7.01
top - 14:21:18 up 32 min,  6 users,  load average: 10.23, 9.57, 7.04
top - 14:21:23 up 33 min,  6 users,  load average: 10.13, 9.56, 7.05
top - 14:21:28 up 33 min,  6 users,  load average: 10.19, 9.59, 7.08
top - 14:21:33 up 33 min,  6 users,  load average: 10.17, 9.60, 7.10
top - 14:21:38 up 33 min,  6 users,  load average: 10.40, 9.65, 7.13
top - 14:21:43 up 33 min,  6 users,  load average: 10.45, 9.67, 7.15
top - 14:21:49 up 33 min,  6 users,  load average: 10.65, 9.73, 7.18
top - 14:21:54 up 33 min,  6 users,  load average: 10.52, 9.72, 7.19
top - 14:21:59 up 33 min,  6 users,  load average: 10.64, 9.75, 7.22
top - 14:22:04 up 33 min,  6 users,  load average: 10.59, 9.76, 7.23
top - 14:22:09 up 33 min,  6 users,  load average: 10.54, 9.76, 7.25
top - 14:22:14 up 33 min,  6 users,  load average: 11.14, 9.90, 7.30
top - 14:22:19 up 34 min,  6 users,  load average: 11.21, 9.93, 7.33
top - 14:22:24 up 34 min,  6 users,  load average: 11.03, 9.92, 7.34
top - 14:22:29 up 34 min,  6 users,  load average: 11.11, 9.95, 7.36
top - 14:22:34 up 34 min,  6 users,  load average: 10.86, 9.92, 7.37
top - 14:22:39 up 34 min,  6 users,  load average: 10.79, 9.92, 7.38
top - 14:22:44 up 34 min,  6 users,  load average: 10.81, 9.94, 7.40
top - 14:22:49 up 34 min,  6 users,  load average: 10.82, 9.96, 7.42
top - 14:22:54 up 34 min,  6 users,  load average: 10.59, 9.92, 7.42
top - 14:22:59 up 34 min,  6 users,  load average: 10.63, 9.94, 7.44
top - 14:23:04 up 34 min,  6 users,  load average: 10.58, 9.94, 7.45
top - 14:23:10 up 34 min,  6 users,  load average: 10.37, 9.91, 7.46
top - 14:23:15 up 34 min,  6 users,  load average: 10.34, 9.91, 7.47
top - 14:23:20 up 35 min,  6 users,  load average: 10.39, 9.93, 7.49
top - 14:23:25 up 35 min,  6 users,  load average: 10.52, 9.96, 7.51
top - 14:23:30 up 35 min,  6 users,  load average: 10.56, 9.98, 7.53
top - 14:23:35 up 35 min,  6 users,  load average: 10.59, 10.00, 7.55
top - 14:23:40 up 35 min,  6 users,  load average: 10.71, 10.03, 7.57
top - 14:23:45 up 35 min,  6 users,  load average: 10.73, 10.05, 7.59
top - 14:23:50 up 35 min,  6 users,  load average: 10.83, 10.08, 7.61
top - 14:23:55 up 35 min,  6 users,  load average: 11.08, 10.14, 7.65
top - 14:24:00 up 35 min,  6 users,  load average: 11.00, 10.14, 7.66
top - 14:24:05 up 35 min,  6 users,  load average: 10.92, 10.14, 7.67
top - 14:24:10 up 35 min,  6 users,  load average: 10.76, 10.12, 7.68
top - 14:24:15 up 35 min,  6 users,  load average: 10.78, 10.13, 7.70
top - 14:24:20 up 36 min,  6 users,  load average: 12.88, 10.58, 7.85
top - 14:24:25 up 36 min,  6 users,  load average: 13.05, 10.65, 7.89
top - 14:24:30 up 36 min,  6 users,  load average: 12.89, 10.66, 7.91
top - 14:24:35 up 36 min,  6 users,  load average: 12.82, 10.68, 7.93
top - 14:24:40 up 36 min,  6 users,  load average: 12.59, 10.67, 7.94
top - 14:24:46 up 36 min,  6 users,  load average: 12.46, 10.67, 7.96
top - 14:24:51 up 36 min,  6 users,  load average: 12.51, 10.71, 7.98
top - 14:24:56 up 36 min,  6 users,  load average: 12.30, 10.70, 8.00
top - 14:25:01 up 36 min,  6 users,  load average: 12.12, 10.69, 8.01
top - 14:25:06 up 36 min,  6 users,  load average: 12.03, 10.69, 8.02
top - 14:25:11 up 36 min,  6 users,  load average: 12.19, 10.75, 8.05
top - 14:25:16 up 36 min,  6 users,  load average: 11.93, 10.72, 8.06
top - 14:25:21 up 37 min,  6 users,  load average: 11.94, 10.74, 8.08
top - 14:25:26 up 37 min,  6 users,  load average: 11.62, 10.69, 8.08
top - 14:25:31 up 37 min,  6 users,  load average: 11.57, 10.70, 8.09
top - 14:25:36 up 37 min,  6 users,  load average: 11.45, 10.69, 8.10
top - 14:25:41 up 37 min,  6 users,  load average: 11.49, 10.71, 8.12
top - 14:25:46 up 37 min,  6 users,  load average: 11.69, 10.76, 8.16
top - 14:25:51 up 37 min,  6 users,  load average: 11.64, 10.77, 8.17
top - 14:25:56 up 37 min,  6 users,  load average: 11.58, 10.77, 8.19
top - 14:26:01 up 37 min,  6 users,  load average: 11.46, 10.76, 8.20
top - 14:26:06 up 37 min,  6 users,  load average: 11.58, 10.79, 8.22
top - 14:26:11 up 37 min,  6 users,  load average: 11.53, 10.80, 8.24
top - 14:26:16 up 37 min,  6 users,  load average: 11.41, 10.78, 8.25
top - 14:26:21 up 38 min,  6 users,  load average: 11.22, 10.75, 8.25
top - 14:26:26 up 38 min,  6 users,  load average: 11.04, 10.72, 8.25
top - 14:26:31 up 38 min,  6 users,  load average: 10.88, 10.69, 8.26
top - 14:26:36 up 38 min,  6 users,  load average: 10.89, 10.70, 8.27
top - 14:26:41 up 38 min,  6 users,  load average: 10.73, 10.67, 8.28
top - 14:26:46 up 38 min,  6 users,  load average: 10.68, 10.66, 8.28
top - 14:26:51 up 38 min,  6 users,  load average: 10.70, 10.67, 8.30
top - 14:26:57 up 38 min,  6 users,  load average: 10.81, 10.69, 8.32
top - 14:27:02 up 38 min,  6 users,  load average: 10.66, 10.66, 8.32
top - 14:27:07 up 38 min,  6 users,  load average: 10.85, 10.70, 8.35
top - 14:27:12 up 38 min,  6 users,  load average: 10.70, 10.67, 8.35
top - 14:27:17 up 38 min,  6 users,  load average: 10.72, 10.67, 8.36
top - 14:27:22 up 39 min,  6 users,  load average: 10.91, 10.71, 8.39
top - 14:27:27 up 39 min,  6 users,  load average: 10.99, 10.73, 8.41
top - 14:27:32 up 39 min,  6 users,  load average: 10.99, 10.74, 8.42
top - 14:27:37 up 39 min,  6 users,  load average: 10.99, 10.74, 8.43
top - 14:27:42 up 39 min,  6 users,  load average: 10.99, 10.75, 8.45
top - 14:27:47 up 39 min,  6 users,  load average: 10.99, 10.75, 8.46
top - 14:27:52 up 39 min,  6 users,  load average: 10.99, 10.75, 8.47
top - 14:27:57 up 39 min,  6 users,  load average: 10.99, 10.76, 8.49
top - 14:28:02 up 39 min,  6 users,  load average: 11.07, 10.78, 8.51
top - 14:28:07 up 39 min,  6 users,  load average: 10.99, 10.77, 8.51
top - 14:28:12 up 39 min,  6 users,  load average: 10.99, 10.77, 8.53
top - 14:28:17 up 39 min,  6 users,  load average: 10.91, 10.76, 8.54
top - 14:28:22 up 40 min,  6 users,  load average: 10.76, 10.73, 8.54
top - 14:28:27 up 40 min,  6 users,  load average: 10.70, 10.71, 8.55
top - 14:28:32 up 40 min,  6 users,  load average: 10.72, 10.72, 8.56
top - 14:28:37 up 40 min,  6 users,  load average: 10.58, 10.69, 8.56
top - 14:28:42 up 40 min,  6 users,  load average: 10.61, 10.69, 8.57
top - 14:28:47 up 40 min,  6 users,  load average: 10.49, 10.67, 8.58
top - 14:28:53 up 40 min,  6 users,  load average: 10.45, 10.66, 8.58
top - 14:28:58 up 40 min,  6 users,  load average: 10.33, 10.63, 8.58
top - 14:29:03 up 40 min,  6 users,  load average: 10.46, 10.65, 8.60
top - 14:29:08 up 40 min,  6 users,  load average: 10.43, 10.64, 8.61
top - 14:29:13 up 40 min,  6 users,  load average: 10.39, 10.63, 8.62
top - 14:29:18 up 40 min,  6 users,  load average: 10.68, 10.68, 8.65
top - 14:29:23 up 41 min,  6 users,  load average: 10.79, 10.70, 8.66
top - 14:29:28 up 41 min,  6 users,  load average: 10.64, 10.68, 8.66
top - 14:29:33 up 41 min,  6 users,  load average: 10.75, 10.70, 8.68
top - 14:29:38 up 41 min,  6 users,  load average: 10.85, 10.72, 8.70
top - 14:29:43 up 41 min,  6 users,  load average: 10.78, 10.71, 8.71
top - 14:29:48 up 41 min,  6 users,  load average: 10.96, 10.75, 8.73
top - 14:29:53 up 41 min,  6 users,  load average: 11.12, 10.78, 8.75
top - 14:29:58 up 41 min,  6 users,  load average: 11.19, 10.80, 8.77
top - 14:30:03 up 41 min,  6 users,  load average: 11.55, 10.89, 8.82
top - 14:30:08 up 41 min,  6 users,  load average: 11.43, 10.88, 8.83
top - 14:30:13 up 41 min,  6 users,  load average: 11.23, 10.84, 8.83
top - 14:30:18 up 42 min,  6 users,  load average: 11.13, 10.83, 8.83
top - 14:30:23 up 42 min,  6 users,  load average: 11.20, 10.85, 8.85
top - 14:30:28 up 42 min,  6 users,  load average: 11.03, 10.82, 8.85
top - 14:30:34 up 42 min,  6 users,  load average: 10.94, 10.80, 8.85
top - 14:30:39 up 42 min,  6 users,  load average: 10.87, 10.79, 8.86
top - 14:30:44 up 42 min,  6 users,  load average: 10.64, 10.74, 8.86
top - 14:30:49 up 42 min,  6 users,  load average: 10.59, 10.73, 8.86
top - 14:30:54 up 42 min,  6 users,  load average: 10.62, 10.74, 8.87
top - 14:30:59 up 42 min,  6 users,  load average: 10.65, 10.74, 8.88
top - 14:31:04 up 42 min,  6 users,  load average: 10.68, 10.74, 8.90
top - 14:31:09 up 42 min,  6 users,  load average: 10.78, 10.76, 8.91
top - 14:31:14 up 42 min,  6 users,  load average: 10.64, 10.74, 8.91
top - 14:31:19 up 43 min,  6 users,  load average: 10.67, 10.74, 8.92
top - 14:31:24 up 43 min,  6 users,  load average: 10.69, 10.74, 8.93
top - 14:31:29 up 43 min,  6 users,  load average: 10.72, 10.75, 8.94
top - 14:31:34 up 43 min,  6 users,  load average: 10.66, 10.73, 8.95
top - 14:31:39 up 43 min,  6 users,  load average: 10.77, 10.76, 8.97
top - 14:31:44 up 43 min,  6 users,  load average: 10.79, 10.76, 8.98
top - 14:31:49 up 43 min,  6 users,  load average: 10.64, 10.73, 8.98
top - 14:31:54 up 43 min,  6 users,  load average: 10.99, 10.80, 9.01
top - 14:31:59 up 43 min,  6 users,  load average: 10.83, 10.77, 9.01
top - 14:32:05 up 43 min,  6 users,  load average: 10.68, 10.74, 9.01
top - 14:32:10 up 43 min,  6 users,  load average: 10.63, 10.73, 9.01
top - 14:32:15 up 43 min,  6 users,  load average: 10.74, 10.75, 9.03
top - 14:32:20 up 44 min,  6 users,  load average: 10.76, 10.75, 9.04
top - 14:32:25 up 44 min,  6 users,  load average: 10.94, 10.79, 9.06
top - 14:32:30 up 44 min,  6 users,  load average: 10.86, 10.78, 9.06
top - 14:32:35 up 44 min,  6 users,  load average: 10.87, 10.78, 9.07
top - 14:32:40 up 44 min,  6 users,  load average: 10.88, 10.78, 9.08
top - 14:32:45 up 44 min,  6 users,  load average: 10.89, 10.79, 9.10
top - 14:32:50 up 44 min,  6 users,  load average: 10.90, 10.79, 9.10
top - 14:32:55 up 44 min,  6 users,  load average: 10.99, 10.81, 9.12
top - 14:33:00 up 44 min,  6 users,  load average: 11.07, 10.83, 9.14
top - 14:33:05 up 44 min,  6 users,  load average: 10.90, 10.80, 9.13
top - 14:33:10 up 44 min,  6 users,  load average: 10.75, 10.77, 9.13
top - 14:33:15 up 44 min,  6 users,  load average: 11.01, 10.82, 9.16
top - 14:33:20 up 45 min,  6 users,  load average: 11.17, 10.86, 9.18
top - 14:33:25 up 45 min,  6 users,  load average: 11.16, 10.86, 9.19
top - 14:33:30 up 45 min,  6 users,  load average: 11.22, 10.88, 9.20
top - 14:33:35 up 45 min,  6 users,  load average: 11.13, 10.86, 9.21
top - 14:33:41 up 45 min,  6 users,  load average: 11.12, 10.87, 9.22
top - 14:33:46 up 45 min,  6 users,  load average: 11.19, 10.88, 9.23
top - 14:33:51 up 45 min,  6 users,  load average: 11.17, 10.89, 9.24
top - 14:33:56 up 45 min,  6 users,  load average: 11.08, 10.87, 9.25
top - 14:34:01 up 45 min,  6 users,  load average: 10.99, 10.86, 9.25
top - 14:34:06 up 45 min,  6 users,  load average: 10.91, 10.84, 9.25
top - 14:34:11 up 45 min,  6 users,  load average: 10.76, 10.81, 9.25
top - 14:34:16 up 45 min,  6 users,  load average: 11.02, 10.86, 9.28
top - 14:34:21 up 46 min,  6 users,  load average: 11.10, 10.88, 9.29
top - 14:34:26 up 46 min,  6 users,  load average: 11.17, 10.90, 9.31
top - 14:34:31 up 46 min,  6 users,  load average: 11.23, 10.92, 9.32
top - 14:34:36 up 46 min,  6 users,  load average: 11.13, 10.90, 9.32
top - 14:34:41 up 46 min,  6 users,  load average: 11.20, 10.92, 9.34
top - 14:34:46 up 46 min,  6 users,  load average: 11.03, 10.89, 9.33
top - 14:34:51 up 46 min,  6 users,  load average: 11.10, 10.91, 9.35
top - 14:34:56 up 46 min,  6 users,  load average: 10.86, 10.86, 9.34
top - 14:35:01 up 46 min,  6 users,  load average: 10.95, 10.88, 9.36
top - 14:35:06 up 46 min,  6 users,  load average: 10.79, 10.85, 9.35
top - 14:35:11 up 46 min,  6 users,  load average: 11.21, 10.93, 9.39
top - 14:35:16 up 46 min,  6 users,  load average: 11.19, 10.93, 9.40
top - 14:35:21 up 47 min,  6 users,  load average: 11.09, 10.92, 9.40
top - 14:35:27 up 47 min,  6 users,  load average: 11.01, 10.90, 9.40
top - 14:35:32 up 47 min,  6 users,  load average: 11.01, 10.90, 9.41
top - 14:35:37 up 47 min,  6 users,  load average: 11.09, 10.92, 9.43
top - 14:35:42 up 47 min,  6 users,  load average: 11.00, 10.91, 9.43
top - 14:35:47 up 47 min,  6 users,  load average: 10.92, 10.89, 9.43
top - 14:35:52 up 47 min,  6 users,  load average: 11.00, 10.91, 9.45
top - 14:35:57 up 47 min,  6 users,  load average: 11.08, 10.93, 9.46
top - 14:36:02 up 47 min,  6 users,  load average: 11.24, 10.96, 9.48
top - 14:36:07 up 47 min,  6 users,  load average: 11.06, 10.93, 9.47
top - 14:36:12 up 47 min,  6 users,  load average: 11.45, 11.01, 9.51
top - 14:36:17 up 47 min,  6 users,  load average: 11.42, 11.01, 9.52
top - 14:36:22 up 48 min,  6 users,  load average: 11.46, 11.03, 9.53
top - 14:36:27 up 48 min,  6 users,  load average: 11.75, 11.09, 9.56
top - 14:36:32 up 48 min,  6 users,  load average: 11.53, 11.06, 9.56
top - 14:36:37 up 48 min,  6 users,  load average: 11.64, 11.09, 9.57
top - 14:36:42 up 48 min,  6 users,  load average: 11.67, 11.10, 9.59
top - 14:36:47 up 48 min,  6 users,  load average: 11.62, 11.10, 9.59
top - 14:36:52 up 48 min,  6 users,  load average: 11.65, 11.12, 9.61
top - 14:36:57 up 48 min,  6 users,  load average: 11.68, 11.13, 9.62
top - 14:37:02 up 48 min,  6 users,  load average: 11.70, 11.15, 9.63
top - 14:37:07 up 48 min,  6 users,  load average: 12.05, 11.23, 9.67
top - 14:37:13 up 48 min,  6 users,  load average: 12.20, 11.27, 9.69
top - 14:37:18 up 48 min,  6 users,  load average: 12.03, 11.25, 9.69
top - 14:37:23 up 49 min,  6 users,  load average: 12.10, 11.28, 9.71
top - 14:37:28 up 49 min,  6 users,  load average: 12.74, 11.42, 9.76
top - 14:37:33 up 49 min,  6 users,  load average: 12.68, 11.43, 9.78
top - 14:37:38 up 49 min,  6 users,  load average: 12.30, 11.38, 9.77
top - 14:37:43 up 49 min,  6 users,  load average: 12.52, 11.44, 9.79
top - 14:37:48 up 49 min,  6 users,  load average: 12.24, 11.40, 9.79
top - 14:37:53 up 49 min,  6 users,  load average: 12.22, 11.41, 9.80
top - 14:37:58 up 49 min,  6 users,  load average: 12.28, 11.43, 9.82
top - 14:38:03 up 49 min,  6 users,  load average: 12.10, 11.41, 9.82
top - 14:38:08 up 49 min,  6 users,  load average: 11.93, 11.38, 9.82
top - 14:38:13 up 49 min,  6 users,  load average: 11.77, 11.36, 9.82
top - 14:38:18 up 49 min,  6 users,  load average: 11.87, 11.39, 9.84
top - 14:38:23 up 50 min,  6 users,  load average: 12.12, 11.45, 9.86
top - 14:38:28 up 50 min,  6 users,  load average: 12.19, 11.47, 9.88
top - 14:38:33 up 50 min,  6 users,  load average: 12.10, 11.46, 9.89
top - 14:38:38 up 50 min,  6 users,  load average: 12.95, 11.68, 9.97
top - 14:38:43 up 50 min,  6 users,  load average: 12.80, 11.67, 9.98
top - 14:38:48 up 50 min,  6 users,  load average: 12.57, 11.64, 9.98
top - 14:38:54 up 50 min,  6 users,  load average: 12.69, 11.68, 10.00
top - 14:38:59 up 50 min,  6 users,  load average: 12.63, 11.68, 10.01
top - 14:39:04 up 50 min,  6 users,  load average: 12.42, 11.65, 10.01
top - 14:39:09 up 50 min,  6 users,  load average: 12.31, 11.64, 10.01
top - 14:39:14 up 50 min,  6 users,  load average: 12.12, 11.61, 10.01
top - 14:39:19 up 51 min,  6 users,  load average: 12.03, 11.60, 10.02
top - 14:39:24 up 51 min,  6 users,  load average: 11.71, 11.54, 10.01
top - 14:39:29 up 51 min,  6 users,  load average: 12.21, 11.65, 10.05
top - 14:39:34 up 51 min,  6 users,  load average: 12.03, 11.62, 10.05
top - 14:39:39 up 51 min,  6 users,  load average: 11.87, 11.60, 10.05
top - 14:39:44 up 51 min,  6 users,  load average: 11.64, 11.55, 10.04
top - 14:39:50 up 51 min,  6 users,  load average: 11.59, 11.54, 10.05
top - 14:39:55 up 51 min,  6 users,  load average: 11.38, 11.50, 10.04
top - 14:40:00 up 51 min,  6 users,  load average: 11.27, 11.48, 10.04
top - 14:40:05 up 51 min,  6 users,  load average: 11.01, 11.42, 10.03
top - 14:40:10 up 51 min,  6 users,  load average: 10.93, 11.39, 10.03
top - 14:40:15 up 51 min,  6 users,  load average: 10.85, 11.37, 10.03
top - 14:40:20 up 52 min,  6 users,  load average: 10.94, 11.38, 10.04
top - 14:40:25 up 52 min,  6 users,  load average: 10.87, 11.36, 10.04
top - 14:40:30 up 52 min,  6 users,  load average: 10.80, 11.33, 10.04
top - 14:40:35 up 52 min,  6 users,  load average: 10.81, 11.33, 10.04
top - 14:40:40 up 52 min,  6 users,  load average: 10.67, 11.29, 10.04
top - 14:40:45 up 52 min,  6 users,  load average: 10.86, 11.32, 10.05
top - 14:40:50 up 52 min,  6 users,  load average: 10.87, 11.31, 10.06
top - 14:40:55 up 52 min,  6 users,  load average: 10.96, 11.32, 10.07
top - 14:41:00 up 52 min,  6 users,  load average: 10.96, 11.32, 10.07
top - 14:41:05 up 52 min,  6 users,  load average: 11.20, 11.36, 10.09
top - 14:41:10 up 52 min,  6 users,  load average: 11.43, 11.41, 10.12
top - 14:41:16 up 52 min,  6 users,  load average: 11.47, 11.42, 10.12
top - 14:41:21 up 53 min,  6 users,  load average: 11.35, 11.39, 10.12
top - 14:41:26 up 53 min,  6 users,  load average: 11.41, 11.40, 10.13
top - 14:41:31 up 53 min,  6 users,  load average: 11.21, 11.36, 10.13
top - 14:41:36 up 53 min,  6 users,  load average: 11.28, 11.37, 10.14
top - 14:41:41 up 53 min,  6 users,  load average: 11.25, 11.37, 10.14
top - 14:41:46 up 53 min,  6 users,  load average: 11.15, 11.34, 10.14
top - 14:41:51 up 53 min,  6 users,  load average: 11.30, 11.37, 10.16
top - 14:41:56 up 53 min,  6 users,  load average: 11.28, 11.36, 10.16
top - 14:42:01 up 53 min,  6 users,  load average: 11.17, 11.34, 10.16
top - 14:42:06 up 53 min,  6 users,  load average: 11.16, 11.33, 10.16
top - 14:42:11 up 53 min,  6 users,  load average: 10.99, 11.30, 10.16
top - 14:42:16 up 53 min,  6 users,  load average: 10.83, 11.26, 10.15
top - 14:42:21 up 54 min,  6 users,  load average: 11.08, 11.30, 10.17
top - 14:42:26 up 54 min,  6 users,  load average: 10.99, 11.28, 10.17
top - 14:42:31 up 54 min,  6 users,  load average: 11.07, 11.29, 10.18
top - 14:42:37 up 54 min,  6 users,  load average: 10.99, 11.27, 10.18
top - 14:42:42 up 54 min,  6 users,  load average: 10.83, 11.23, 10.17
top - 14:42:47 up 54 min,  6 users,  load average: 10.68, 11.20, 10.17
top - 14:42:52 up 54 min,  6 users,  load average: 10.79, 11.21, 10.18
top - 14:42:57 up 54 min,  6 users,  load average: 10.88, 11.22, 10.19
top - 14:43:02 up 54 min,  6 users,  load average: 11.05, 11.25, 10.20
top - 14:43:07 up 54 min,  6 users,  load average: 10.89, 11.21, 10.19
top - 14:43:12 up 54 min,  6 users,  load average: 10.82, 11.19, 10.19
top - 14:43:17 up 54 min,  6 users,  load average: 10.83, 11.19, 10.20
top - 14:43:22 up 55 min,  6 users,  load average: 11.00, 11.22, 10.21
top - 14:43:27 up 55 min,  6 users,  load average: 11.00, 11.21, 10.21
top - 14:43:32 up 55 min,  6 users,  load average: 10.76, 11.16, 10.20
top - 14:43:37 up 55 min,  6 users,  load average: 10.06, 11.01, 10.16
top - 14:43:42 up 55 min,  6 users,  load average: 9.42, 10.86, 10.11
top - 14:43:47 up 55 min,  6 users,  load average: 8.90, 10.73, 10.08
top - 14:43:52 up 55 min,  6 users,  load average: 8.27, 10.57, 10.03
top - 14:43:57 up 55 min,  6 users,  load average: 8.01, 10.47, 10.00
top - 14:44:02 up 55 min,  6 users,  load average: 7.44, 10.32, 9.95
top - 14:44:07 up 55 min,  6 users,  load average: 6.93, 10.16, 9.90
top - 14:44:12 up 55 min,  6 users,  load average: 6.69, 10.06, 9.87
top - 14:44:17 up 55 min,  6 users,  load average: 6.64, 9.99, 9.85
top - 14:44:22 up 56 min,  6 users,  load average: 6.27, 9.86, 9.81
top - 14:44:27 up 56 min,  6 users,  load average: 5.84, 9.71, 9.76
top - 14:44:32 up 56 min,  6 users,  load average: 5.78, 9.63, 9.73
top - 14:44:37 up 56 min,  6 users,  load average: 5.63, 9.54, 9.70
top - 14:44:43 up 56 min,  6 users,  load average: 5.90, 9.53, 9.70
top - 14:44:48 up 56 min,  6 users,  load average: 6.95, 9.69, 9.75
top - 14:44:53 up 56 min,  6 users,  load average: 7.28, 9.71, 9.76
top - 14:44:58 up 56 min,  6 users,  load average: 7.49, 9.71, 9.76
top - 14:45:03 up 56 min,  6 users,  load average: 8.09, 9.80, 9.78
top - 14:45:08 up 56 min,  6 users,  load average: 8.25, 9.80, 9.79
top - 14:45:13 up 56 min,  6 users,  load average: 8.71, 9.87, 9.81
top - 14:45:18 up 56 min,  6 users,  load average: 8.65, 9.84, 9.80
top - 14:45:23 up 57 min,  6 users,  load average: 8.76, 9.84, 9.80
top - 14:45:28 up 57 min,  6 users,  load average: 8.86, 9.85, 9.80
top - 14:45:33 up 57 min,  6 users,  load average: 9.19, 9.90, 9.82
top - 14:45:38 up 57 min,  6 users,  load average: 9.49, 9.95, 9.83
top - 14:45:43 up 57 min,  6 users,  load average: 9.61, 9.97, 9.84
top - 14:45:48 up 57 min,  6 users,  load average: 10.05, 10.05, 9.87
top - 14:45:53 up 57 min,  6 users,  load average: 10.28, 10.10, 9.88
top - 14:45:58 up 57 min,  6 users,  load average: 10.34, 10.11, 9.89
top - 14:46:03 up 57 min,  6 users,  load average: 10.55, 10.16, 9.91
top - 14:46:08 up 57 min,  6 users,  load average: 10.67, 10.19, 9.92
top - 14:46:13 up 57 min,  6 users,  load average: 11.09, 10.30, 9.95
top - 14:46:18 up 58 min,  6 users,  load average: 10.92, 10.28, 9.95
top - 14:46:23 up 58 min,  6 users,  load average: 11.33, 10.37, 9.98
top - 14:46:28 up 58 min,  6 users,  load average: 11.38, 10.40, 9.99
top - 14:46:34 up 58 min,  6 users,  load average: 11.19, 10.38, 9.99
top - 14:46:39 up 58 min,  6 users,  load average: 11.02, 10.35, 9.98
top - 14:46:44 up 58 min,  6 users,  load average: 10.94, 10.35, 9.98
top - 14:46:49 up 58 min,  6 users,  load average: 10.94, 10.36, 9.99
top - 14:46:54 up 58 min,  6 users,  load average: 11.02, 10.38, 10.00
top - 14:46:59 up 58 min,  6 users,  load average: 10.86, 10.36, 9.99
top - 14:47:04 up 58 min,  6 users,  load average: 10.87, 10.37, 10.00
top - 14:47:09 up 58 min,  6 users,  load average: 10.80, 10.36, 10.00
top - 14:47:14 up 58 min,  6 users,  load average: 10.74, 10.36, 10.00
top - 14:47:19 up 59 min,  6 users,  load average: 10.84, 10.39, 10.01
top - 14:47:24 up 59 min,  6 users,  load average: 10.85, 10.39, 10.01
top - 14:47:29 up 59 min,  6 users,  load average: 11.02, 10.44, 10.03
top - 14:47:34 up 59 min,  6 users,  load average: 10.94, 10.43, 10.03
top - 14:47:39 up 59 min,  6 users,  load average: 10.87, 10.42, 10.03
top - 14:47:44 up 59 min,  6 users,  load average: 10.72, 10.40, 10.02
top - 14:47:49 up 59 min,  6 users,  load average: 10.66, 10.39, 10.02
top - 14:47:54 up 59 min,  6 users,  load average: 10.69, 10.40, 10.03
top - 14:47:59 up 59 min,  6 users,  load average: 10.71, 10.41, 10.03
top - 14:48:04 up 59 min,  6 users,  load average: 10.73, 10.42, 10.04
top - 14:48:09 up 59 min,  6 users,  load average: 10.75, 10.43, 10.04
top - 14:48:14 up 59 min,  6 users,  load average: 10.77, 10.44, 10.05
top - 14:48:20 up  1:00,  6 users,  load average: 11.03, 10.50, 10.07
top - 14:48:25 up  1:00,  6 users,  load average: 11.27, 10.56, 10.09
top - 14:48:30 up  1:00,  6 users,  load average: 11.33, 10.58, 10.10
top - 14:48:35 up  1:00,  6 users,  load average: 11.14, 10.55, 10.09
top - 14:48:40 up  1:00,  6 users,  load average: 11.29, 10.60, 10.11
top - 14:48:45 up  1:00,  6 users,  load average: 11.43, 10.63, 10.12
top - 14:48:50 up  1:00,  6 users,  load average: 11.47, 10.66, 10.13
top - 14:48:55 up  1:00,  6 users,  load average: 11.51, 10.68, 10.14
top - 14:49:00 up  1:00,  6 users,  load average: 11.39, 10.67, 10.14
top - 14:49:05 up  1:00,  6 users,  load average: 11.52, 10.71, 10.16
top - 14:49:10 up  1:00,  6 users,  load average: 11.40, 10.69, 10.16
top - 14:49:15 up  1:00,  6 users,  load average: 11.45, 10.72, 10.16
top - 14:49:20 up  1:01,  6 users,  load average: 11.41, 10.72, 10.17
top - 14:49:25 up  1:01,  6 users,  load average: 11.30, 10.71, 10.17
top - 14:49:30 up  1:01,  6 users,  load average: 11.75, 10.81, 10.20
top - 14:49:35 up  1:01,  6 users,  load average: 11.53, 10.78, 10.20
top - 14:49:40 up  1:01,  6 users,  load average: 11.41, 10.77, 10.20
top - 14:49:45 up  1:01,  6 users,  load average: 11.46, 10.79, 10.21
top - 14:49:50 up  1:01,  6 users,  load average: 11.34, 10.77, 10.20
top - 14:49:55 up  1:01,  6 users,  load average: 11.15, 10.75, 10.20
top - 14:50:00 up  1:01,  6 users,  load average: 11.38, 10.80, 10.22
top - 14:50:05 up  1:01,  6 users,  load average: 11.03, 10.74, 10.20
top - 14:50:10 up  1:01,  6 users,  load average: 11.11, 10.76, 10.21
top - 14:50:15 up  1:01,  6 users,  load average: 10.86, 10.71, 10.20
top - 14:50:20 up  1:02,  6 users,  load average: 11.11, 10.76, 10.22
top - 14:50:25 up  1:02,  6 users,  load average: 11.42, 10.83, 10.24
top - 14:50:31 up  1:02,  6 users,  load average: 11.47, 10.85, 10.25
top - 14:50:36 up  1:02,  6 users,  load average: 11.59, 10.89, 10.27
top - 14:50:41 up  1:02,  6 users,  load average: 11.94, 10.97, 10.30
top - 14:50:46 up  1:02,  6 users,  load average: 12.19, 11.04, 10.32
top - 14:50:51 up  1:02,  6 users,  load average: 12.65, 11.15, 10.36
top - 14:50:56 up  1:02,  6 users,  load average: 12.92, 11.23, 10.39
top - 14:51:01 up  1:02,  6 users,  load average: 13.17, 11.31, 10.42
top - 14:51:06 up  1:02,  6 users,  load average: 13.47, 11.41, 10.46
top - 14:51:11 up  1:02,  6 users,  load average: 13.76, 11.50, 10.49
top - 14:51:16 up  1:02,  6 users,  load average: 14.02, 11.59, 10.53
top - 14:51:21 up  1:03,  6 users,  load average: 13.37, 11.50, 10.50
top - 14:51:26 up  1:03,  6 users,  load average: 12.86, 11.42, 10.48
top - 14:51:31 up  1:03,  6 users,  load average: 12.23, 11.32, 10.45
top - 14:51:36 up  1:03,  6 users,  load average: 11.65, 11.21, 10.42
top - 14:51:41 up  1:03,  6 users,  load average: 11.20, 11.12, 10.40
top - 14:51:46 up  1:03,  6 users,  load average: 10.62, 11.01, 10.37
top - 14:51:51 up  1:03,  6 users,  load average: 9.93, 10.86, 10.32
top - 14:51:56 up  1:03,  6 users,  load average: 9.38, 10.73, 10.28
top - 14:52:01 up  1:03,  6 users,  load average: 8.95, 10.61, 10.25
top - 14:52:06 up  1:03,  6 users,  load average: 8.47, 10.49, 10.21
top - 14:52:12 up  1:03,  6 users,  load average: 7.95, 10.35, 10.16
top - 14:52:17 up  1:03,  6 users,  load average: 7.55, 10.22, 10.12
top - 14:52:22 up  1:04,  6 users,  load average: 7.27, 10.12, 10.09
top - 14:52:27 up  1:04,  6 users,  load average: 7.01, 10.02, 10.06
top - 14:52:32 up  1:04,  6 users,  load average: 6.61, 9.89, 10.02
top - 14:52:37 up  1:04,  6 users,  load average: 6.40, 9.79, 9.98
top - 14:52:42 up  1:04,  6 users,  load average: 6.12, 9.67, 9.94
top - 14:52:47 up  1:04,  6 users,  load average: 6.03, 9.60, 9.92
top - 14:52:52 up  1:04,  6 users,  load average: 5.95, 9.52, 9.89
top - 14:52:57 up  1:04,  6 users,  load average: 5.79, 9.43, 9.86
top - 14:53:02 up  1:04,  6 users,  load average: 5.65, 9.34, 9.83
top - 14:53:07 up  1:04,  6 users,  load average: 5.44, 9.23, 9.79
top - 14:53:12 up  1:04,  6 users,  load average: 5.24, 9.13, 9.75
top - 14:53:17 up  1:04,  6 users,  load average: 5.22, 9.06, 9.73
top - 14:53:22 up  1:05,  6 users,  load average: 4.97, 8.94, 9.69
top - 14:53:27 up  1:05,  6 users,  load average: 5.05, 8.89, 9.67
top - 14:53:32 up  1:05,  6 users,  load average: 5.36, 8.89, 9.66
top - 14:53:37 up  1:05,  6 users,  load average: 5.09, 8.78, 9.62
top - 14:53:42 up  1:05,  6 users,  load average: 4.85, 8.67, 9.58
top - 14:53:47 up  1:05,  6 users,  load average: 4.62, 8.56, 9.54
top - 14:53:52 up  1:05,  6 users,  load average: 4.33, 8.43, 9.49
top - 14:53:57 up  1:05,  6 users,  load average: 4.30, 8.36, 9.46
top - 14:54:02 up  1:05,  6 users,  load average: 4.04, 8.23, 9.42
top - 14:54:07 up  1:05,  6 users,  load average: 3.95, 8.15, 9.38
top - 14:54:12 up  1:05,  6 users,  load average: 4.04, 8.09, 9.36
top - 14:54:17 up  1:05,  6 users,  load average: 4.03, 8.03, 9.33
top - 14:54:22 up  1:06,  6 users,  load average: 5.07, 8.18, 9.37
top - 14:54:27 up  1:06,  6 users,  load average: 4.91, 8.09, 9.34
top - 14:54:32 up  1:06,  6 users,  load average: 4.83, 8.02, 9.31
top - 14:54:37 up  1:06,  6 users,  load average: 4.53, 7.90, 9.26
top - 14:54:42 up  1:06,  6 users,  load average: 4.64, 7.87, 9.24
top - 14:54:47 up  1:06,  6 users,  load average: 4.83, 7.86, 9.23
top - 14:54:52 up  1:06,  6 users,  load average: 4.61, 7.76, 9.19
top - 14:54:57 up  1:06,  6 users,  load average: 4.80, 7.75, 9.18
top - 14:55:02 up  1:06,  6 users,  load average: 4.49, 7.64, 9.14
top - 14:55:07 up  1:06,  6 users,  load average: 4.29, 7.54, 9.10
top - 14:55:12 up  1:06,  6 users,  load average: 4.19, 7.47, 9.07
top - 14:55:17 up  1:06,  6 users,  load average: 4.17, 7.41, 9.04
top - 14:55:23 up  1:07,  6 users,  load average: 4.40, 7.40, 9.03
top - 14:55:28 up  1:07,  6 users,  load average: 4.21, 7.31, 8.99
top - 14:55:33 up  1:07,  6 users,  load average: 4.43, 7.31, 8.98
top - 14:55:38 up  1:07,  6 users,  load average: 4.32, 7.23, 8.95
top - 14:55:43 up  1:07,  6 users,  load average: 4.29, 7.18, 8.92
top - 14:55:48 up  1:07,  6 users,  load average: 4.27, 7.13, 8.89
top - 14:55:53 up  1:07,  6 users,  load average: 4.09, 7.04, 8.85
top - 14:55:58 up  1:07,  6 users,  load average: 3.84, 6.94, 8.81
top - 14:56:03 up  1:07,  6 users,  load average: 3.69, 6.86, 8.78
top - 14:56:08 up  1:07,  6 users,  load average: 3.55, 6.78, 8.74
top - 14:56:13 up  1:07,  6 users,  load average: 3.43, 6.70, 8.70
top - 14:56:18 up  1:07,  6 users,  load average: 3.24, 6.60, 8.66
top - 14:56:23 up  1:08,  6 users,  load average: 3.22, 6.54, 8.63
top - 14:56:28 up  1:08,  6 users,  load average: 3.20, 6.48, 8.60
top - 14:56:33 up  1:08,  6 users,  load average: 3.34, 6.46, 8.58
top - 14:56:38 up  1:08,  6 users,  load average: 3.15, 6.37, 8.54
top - 14:56:43 up  1:08,  6 users,  load average: 3.14, 6.31, 8.51
top - 14:56:48 up  1:08,  6 users,  load average: 2.97, 6.22, 8.47
top - 14:56:53 up  1:08,  6 users,  load average: 2.81, 6.14, 8.43
top - 14:56:58 up  1:08,  6 users,  load average: 2.75, 6.07, 8.39
top - 14:57:03 up  1:08,  6 users,  load average: 2.77, 6.02, 8.36
top - 14:57:08 up  1:08,  6 users,  load average: 2.70, 5.95, 8.33
top - 14:57:13 up  1:08,  6 users,  load average: 3.22, 5.95, 8.30
top - 14:57:18 up  1:09,  6 users,  load average: 3.20, 5.90, 8.28
top - 14:57:23 up  1:09,  6 users,  load average: 3.10, 5.84, 8.24
top - 14:57:28 up  1:09,  6 users,  load average: 2.93, 5.76, 8.20
top - 14:57:33 up  1:09,  6 users,  load average: 2.78, 5.68, 8.16
top - 14:57:38 up  1:09,  6 users,  load average: 2.64, 5.60, 8.12
top - 14:57:43 up  1:09,  6 users,  load average: 2.51, 5.52, 8.09
top - 14:57:48 up  1:09,  6 users,  load average: 2.55, 5.48, 8.06
top - 14:57:53 up  1:09,  6 users,  load average: 2.66, 5.46, 8.04
top - 14:57:58 up  1:09,  6 users,  load average: 2.69, 5.41, 8.01
top - 14:58:04 up  1:09,  6 users,  load average: 2.71, 5.37, 7.98
top - 14:58:09 up  1:09,  6 users,  load average: 2.82, 5.35, 7.96
top - 14:58:14 up  1:09,  6 users,  load average: 2.91, 5.33, 7.94
top - 14:58:19 up  1:10,  6 users,  load average: 2.92, 5.29, 7.91
top - 14:58:24 up  1:10,  6 users,  load average: 2.76, 5.22, 7.87
top - 14:58:29 up  1:10,  6 users,  load average: 2.86, 5.20, 7.85
top - 14:58:34 up  1:10,  6 users,  load average: 2.79, 5.14, 7.82
top - 14:58:39 up  1:10,  6 users,  load average: 2.65, 5.08, 7.79
top - 14:58:44 up  1:10,  6 users,  load average: 2.76, 5.06, 7.76
top - 14:58:49 up  1:10,  6 users,  load average: 2.62, 4.99, 7.73
top - 14:58:54 up  1:10,  6 users,  load average: 2.65, 4.96, 7.70
top - 14:58:59 up  1:10,  6 users,  load average: 2.51, 4.89, 7.67
top - 14:59:04 up  1:10,  6 users,  load average: 2.63, 4.88, 7.65
top - 14:59:09 up  1:10,  6 users,  load average: 2.82, 4.88, 7.63
top - 14:59:14 up  1:10,  6 users,  load average: 2.68, 4.81, 7.60
top - 14:59:19 up  1:11,  6 users,  load average: 2.62, 4.77, 7.57
top - 14:59:24 up  1:11,  6 users,  load average: 2.57, 4.72, 7.54
top - 14:59:29 up  1:11,  6 users,  load average: 2.69, 4.71, 7.52
top - 14:59:34 up  1:11,  6 users,  load average: 2.63, 4.66, 7.49
top - 14:59:39 up  1:11,  6 users,  load average: 2.50, 4.60, 7.45
top - 14:59:44 up  1:11,  6 users,  load average: 2.54, 4.58, 7.43
top - 14:59:49 up  1:11,  6 users,  load average: 2.42, 4.52, 7.39
top - 14:59:54 up  1:11,  6 users,  load average: 2.38, 4.47, 7.36
top - 14:59:59 up  1:11,  6 users,  load average: 2.59, 4.48, 7.35
top - 15:00:04 up  1:11,  6 users,  load average: 2.70, 4.47, 7.33
top - 15:00:09 up  1:11,  6 users,  load average: 2.57, 4.42, 7.30
top - 15:00:14 up  1:11,  6 users,  load average: 2.44, 4.36, 7.26
top - 15:00:19 up  1:12,  6 users,  load average: 2.49, 4.34, 7.24
top - 15:00:24 up  1:12,  6 users,  load average: 2.53, 4.31, 7.22
top - 15:00:29 up  1:12,  6 users,  load average: 2.40, 4.26, 7.18
top - 15:00:34 up  1:12,  6 users,  load average: 2.37, 4.22, 7.16
top - 15:00:39 up  1:12,  6 users,  load average: 2.34, 4.18, 7.13
top - 15:00:44 up  1:12,  6 users,  load average: 2.23, 4.13, 7.10
top - 15:00:49 up  1:12,  6 users,  load average: 2.29, 4.11, 7.07
top - 15:00:55 up  1:12,  6 users,  load average: 2.19, 4.06, 7.04
top - 15:01:00 up  1:12,  6 users,  load average: 2.18, 4.02, 7.01
top - 15:01:05 up  1:12,  6 users,  load average: 2.08, 3.97, 6.98
top - 15:01:10 up  1:12,  6 users,  load average: 1.99, 3.92, 6.95
top - 15:01:15 up  1:12,  6 users,  load average: 1.99, 3.89, 6.92
top - 15:01:20 up  1:13,  6 users,  load average: 1.91, 3.84, 6.89
top - 15:01:25 up  1:13,  6 users,  load average: 1.84, 3.80, 6.86
top - 15:01:30 up  1:13,  6 users,  load average: 1.93, 3.78, 6.84
top - 15:01:35 up  1:13,  6 users,  load average: 1.86, 3.74, 6.80
top - 15:01:40 up  1:13,  6 users,  load average: 1.95, 3.72, 6.78
top - 15:01:45 up  1:13,  6 users,  load average: 2.03, 3.71, 6.76
top - 15:01:50 up  1:13,  6 users,  load average: 2.27, 3.73, 6.75
top - 15:01:55 up  1:13,  6 users,  load average: 2.41, 3.74, 6.74
top - 15:02:00 up  1:13,  6 users,  load average: 2.46, 3.72, 6.72
top - 15:02:05 up  1:13,  6 users,  load average: 2.50, 3.71, 6.70
top - 15:02:10 up  1:13,  6 users,  load average: 2.54, 3.70, 6.68
top - 15:02:15 up  1:13,  6 users,  load average: 2.74, 3.72, 6.67
top - 15:02:20 up  1:14,  6 users,  load average: 2.92, 3.74, 6.66
top - 15:02:25 up  1:14,  6 users,  load average: 3.08, 3.76, 6.65
top - 15:02:30 up  1:14,  6 users,  load average: 3.32, 3.80, 6.65
top - 15:02:35 up  1:14,  6 users,  load average: 3.13, 3.75, 6.62
top - 15:02:40 up  1:14,  6 users,  load average: 3.04, 3.72, 6.59
top - 15:02:45 up  1:14,  6 users,  load average: 2.96, 3.69, 6.57
top - 15:02:50 up  1:14,  6 users,  load average: 2.88, 3.67, 6.54
top - 15:02:55 up  1:14,  6 users,  load average: 2.97, 3.67, 6.53
top - 15:03:00 up  1:14,  6 users,  load average: 2.97, 3.66, 6.51
top - 15:03:05 up  1:14,  6 users,  load average: 2.89, 3.63, 6.48
top - 15:03:10 up  1:14,  6 users,  load average: 2.82, 3.61, 6.46
top - 15:03:15 up  1:14,  6 users,  load average: 2.68, 3.56, 6.43
top - 15:03:20 up  1:15,  6 users,  load average: 2.54, 3.52, 6.40
top - 15:03:25 up  1:15,  6 users,  load average: 2.42, 3.48, 6.37
top - 15:03:30 up  1:15,  6 users,  load average: 2.62, 3.50, 6.36
top - 15:03:35 up  1:15,  6 users,  load average: 2.73, 3.51, 6.35
top - 15:03:40 up  1:15,  6 users,  load average: 2.76, 3.50, 6.33
top - 15:03:45 up  1:15,  6 users,  load average: 3.10, 3.56, 6.34
top - 15:03:51 up  1:15,  6 users,  load average: 2.93, 3.52, 6.31
top - 15:03:56 up  1:15,  6 users,  load average: 3.01, 3.52, 6.29
top - 15:04:01 up  1:15,  6 users,  load average: 2.93, 3.50, 6.27
top - 15:04:06 up  1:15,  6 users,  load average: 2.86, 3.47, 6.25
top - 15:04:11 up  1:15,  6 users,  load average: 2.79, 3.45, 6.22
top - 15:04:16 up  1:15,  6 users,  load average: 3.04, 3.49, 6.22
top - 15:04:21 up  1:16,  6 users,  load average: 3.20, 3.52, 6.22
top - 15:04:26 up  1:16,  6 users,  load average: 3.18, 3.51, 6.20
top - 15:04:31 up  1:16,  6 users,  load average: 3.25, 3.51, 6.19
top - 15:04:36 up  1:16,  6 users,  load average: 3.07, 3.47, 6.16
top - 15:04:41 up  1:16,  6 users,  load average: 3.14, 3.48, 6.15
top - 15:04:46 up  1:16,  6 users,  load average: 2.89, 3.42, 6.11
top - 15:04:51 up  1:16,  6 users,  load average: 2.66, 3.37, 6.08
top - 15:04:56 up  1:16,  6 users,  load average: 2.61, 3.34, 6.06
top - 15:05:01 up  1:16,  6 users,  load average: 2.56, 3.32, 6.04
top - 15:05:06 up  1:16,  6 users,  load average: 2.35, 3.27, 6.00
top - 15:05:11 up  1:16,  6 users,  load average: 2.16, 3.21, 5.97
top - 15:05:16 up  1:16,  6 users,  load average: 2.23, 3.21, 5.95
top - 15:05:21 up  1:17,  6 users,  load average: 2.13, 3.17, 5.93
top - 15:05:26 up  1:17,  6 users,  load average: 2.20, 3.17, 5.91
top - 15:05:31 up  1:17,  6 users,  load average: 2.35, 3.18, 5.90
top - 15:05:36 up  1:17,  6 users,  load average: 2.16, 3.13, 5.87
top - 15:05:41 up  1:17,  6 users,  load average: 1.98, 3.07, 5.84
top - 15:05:46 up  1:17,  6 users,  load average: 1.83, 3.02, 5.81
top - 15:05:51 up  1:17,  6 users,  load average: 1.92, 3.02, 5.79
top - 15:05:56 up  1:17,  6 users,  load average: 2.01, 3.02, 5.78
top - 15:06:01 up  1:17,  6 users,  load average: 1.84, 2.97, 5.74
top - 15:06:06 up  1:17,  6 users,  load average: 1.70, 2.92, 5.71
top - 15:06:11 up  1:17,  6 users,  load average: 1.72, 2.91, 5.69
top - 15:06:16 up  1:17,  6 users,  load average: 1.58, 2.86, 5.66
top - 15:06:21 up  1:18,  6 users,  load average: 1.46, 2.81, 5.63
top - 15:06:26 up  1:18,  6 users,  load average: 1.34, 2.76, 5.60
top - 15:06:31 up  1:18,  6 users,  load average: 1.31, 2.73, 5.58
top - 15:06:36 up  1:18,  6 users,  load average: 1.45, 2.74, 5.56
top - 15:06:41 up  1:18,  6 users,  load average: 1.49, 2.73, 5.54
top - 15:06:46 up  1:18,  6 users,  load average: 1.37, 2.68, 5.51
top - 15:06:51 up  1:18,  6 users,  load average: 1.50, 2.69, 5.50
top - 15:06:56 up  1:18,  6 users,  load average: 1.46, 2.66, 5.47
top - 15:07:01 up  1:18,  6 users,  load average: 1.50, 2.65, 5.46
top - 15:07:06 up  1:18,  6 users,  load average: 1.46, 2.62, 5.43
top - 15:07:11 up  1:18,  6 users,  load average: 1.43, 2.59, 5.41
top - 15:07:16 up  1:18,  6 users,  load average: 1.31, 2.55, 5.38
top - 15:07:21 up  1:19,  6 users,  load average: 1.29, 2.52, 5.35
top - 15:07:26 up  1:19,  6 users,  load average: 1.18, 2.48, 5.33
top - 15:07:31 up  1:19,  6 users,  load average: 1.17, 2.45, 5.30
top - 15:07:36 up  1:19,  6 users,  load average: 1.31, 2.46, 5.29
top - 15:07:41 up  1:19,  6 users,  load average: 1.29, 2.44, 5.27
top - 15:07:46 up  1:19,  6 users,  load average: 1.19, 2.40, 5.24
top - 15:07:52 up  1:19,  6 users,  load average: 1.09, 2.36, 5.21
top - 15:07:57 up  1:19,  6 users,  load average: 1.16, 2.35, 5.19
top - 15:08:02 up  1:19,  6 users,  load average: 1.07, 2.31, 5.16
top - 15:08:07 up  1:19,  6 users,  load average: 0.98, 2.27, 5.14
top - 15:08:12 up  1:19,  6 users,  load average: 1.39, 2.34, 5.14
top - 15:08:17 up  1:19,  6 users,  load average: 1.43, 2.33, 5.12
top - 15:08:22 up  1:20,  6 users,  load average: 1.56, 2.34, 5.11
top - 15:08:27 up  1:20,  6 users,  load average: 1.59, 2.34, 5.09
top - 15:08:32 up  1:20,  6 users,  load average: 1.55, 2.31, 5.07
top - 15:08:37 up  1:20,  6 users,  load average: 1.74, 2.34, 5.07
top - 15:08:42 up  1:20,  6 users,  load average: 1.60, 2.30, 5.04
top - 15:08:47 up  1:20,  6 users,  load average: 1.47, 2.26, 5.01
top - 15:08:52 up  1:20,  6 users,  load average: 1.60, 2.28, 5.00
top - 15:08:57 up  1:20,  6 users,  load average: 1.47, 2.24, 4.97
top - 15:09:02 up  1:20,  6 users,  load average: 1.35, 2.20, 4.95
top - 15:09:07 up  1:20,  6 users,  load average: 1.24, 2.16, 4.92
top - 15:09:12 up  1:20,  6 users,  load average: 1.46, 2.19, 4.91
top - 15:09:17 up  1:20,  6 users,  load average: 1.35, 2.16, 4.89
top - 15:09:22 up  1:21,  6 users,  load average: 1.32, 2.14, 4.87
top - 15:09:27 up  1:21,  6 users,  load average: 1.21, 2.10, 4.84
top - 15:09:32 up  1:21,  6 users,  load average: 1.20, 2.08, 4.82
top - 15:09:37 up  1:21,  6 users,  load average: 1.10, 2.05, 4.79
top - 15:09:42 up  1:21,  6 users,  load average: 1.01, 2.01, 4.77
top - 15:09:47 up  1:21,  6 users,  load average: 1.09, 2.01, 4.75
top - 15:09:52 up  1:21,  6 users,  load average: 1.16, 2.01, 4.74
top - 15:09:57 up  1:21,  6 users,  load average: 1.15, 2.00, 4.72
top - 15:10:02 up  1:21,  6 users,  load average: 1.14, 1.98, 4.70
top - 15:10:07 up  1:21,  6 users,  load average: 1.37, 2.01, 4.69
top - 15:10:12 up  1:21,  6 users,  load average: 1.26, 1.98, 4.67
top - 15:10:17 up  1:21,  6 users,  load average: 1.16, 1.95, 4.64
top - 15:10:22 up  1:22,  6 users,  load average: 1.14, 1.93, 4.62
top - 15:10:27 up  1:22,  6 users,  load average: 1.05, 1.90, 4.60
top - 15:10:32 up  1:22,  6 users,  load average: 1.05, 1.88, 4.58
top - 15:10:37 up  1:22,  6 users,  load average: 1.20, 1.90, 4.57
top - 15:10:42 up  1:22,  6 users,  load average: 1.11, 1.87, 4.54
top - 15:10:47 up  1:22,  6 users,  load average: 1.02, 1.84, 4.52
top - 15:10:52 up  1:22,  6 users,  load average: 1.02, 1.82, 4.50
top - 15:10:57 up  1:22,  6 users,  load average: 0.93, 1.79, 4.47
top - 15:11:02 up  1:22,  6 users,  load average: 0.86, 1.76, 4.45
top - 15:11:07 up  1:22,  6 users,  load average: 1.03, 1.78, 4.44
top - 15:11:12 up  1:22,  6 users,  load average: 0.95, 1.75, 4.42
top - 15:11:17 up  1:22,  6 users,  load average: 1.19, 1.79, 4.42
top - 15:11:22 up  1:23,  6 users,  load average: 1.10, 1.76, 4.39
top - 15:11:27 up  1:23,  6 users,  load average: 1.09, 1.75, 4.37
top - 15:11:32 up  1:23,  6 users,  load average: 1.00, 1.72, 4.35
top - 15:11:37 up  1:23,  6 users,  load average: 0.92, 1.69, 4.33
top - 15:11:42 up  1:23,  6 users,  load average: 0.85, 1.66, 4.30
top - 15:11:47 up  1:23,  6 users,  load average: 0.78, 1.63, 4.28
top - 15:11:52 up  1:23,  6 users,  load average: 0.80, 1.62, 4.26
top - 15:11:57 up  1:23,  6 users,  load average: 0.81, 1.61, 4.24
top - 15:12:02 up  1:23,  6 users,  load average: 0.91, 1.62, 4.23
top - 15:12:08 up  1:23,  6 users,  load average: 0.83, 1.59, 4.21
top - 15:12:13 up  1:23,  6 users,  load average: 0.85, 1.58, 4.19
top - 15:12:18 up  1:23,  6 users,  load average: 0.78, 1.56, 4.17
top - 15:12:23 up  1:24,  6 users,  load average: 0.88, 1.56, 4.16
top - 15:12:28 up  1:24,  6 users,  load average: 1.21, 1.62, 4.16
top - 15:12:33 up  1:24,  6 users,  load average: 1.43, 1.66, 4.16
top - 15:12:38 up  1:24,  6 users,  load average: 1.40, 1.65, 4.14
top - 15:12:43 up  1:24,  6 users,  load average: 1.28, 1.62, 4.12
top - 15:12:48 up  1:24,  6 users,  load average: 1.42, 1.64, 4.11
top - 15:12:53 up  1:24,  6 users,  load average: 1.39, 1.63, 4.10
top - 15:12:58 up  1:24,  6 users,  load average: 1.36, 1.62, 4.08
top - 15:13:03 up  1:24,  6 users,  load average: 1.33, 1.61, 4.06
top - 15:13:08 up  1:24,  6 users,  load average: 1.46, 1.63, 4.06
top - 15:13:13 up  1:24,  6 users,  load average: 1.34, 1.61, 4.04
top - 15:13:18 up  1:24,  6 users,  load average: 1.24, 1.58, 4.01
top - 15:13:23 up  1:25,  6 users,  load average: 1.22, 1.57, 4.00
top - 15:13:28 up  1:25,  6 users,  load average: 1.12, 1.54, 3.97
top - 15:13:33 up  1:25,  6 users,  load average: 1.03, 1.52, 3.95
top - 15:13:38 up  1:25,  6 users,  load average: 1.11, 1.52, 3.94
top - 15:13:43 up  1:25,  6 users,  load average: 1.02, 1.50, 3.92
top - 15:13:48 up  1:25,  6 users,  load average: 1.10, 1.51, 3.91
top - 15:13:53 up  1:25,  6 users,  load average: 1.09, 1.50, 3.89
top - 15:13:58 up  1:25,  6 users,  load average: 1.32, 1.54, 3.89
top - 15:14:03 up  1:25,  6 users,  load average: 1.30, 1.53, 3.88
top - 15:14:08 up  1:25,  6 users,  load average: 1.35, 1.54, 3.87
top - 15:14:13 up  1:25,  6 users,  load average: 1.48, 1.56, 3.86
top - 15:14:18 up  1:25,  6 users,  load average: 1.85, 1.64, 3.88
top - 15:14:23 up  1:26,  6 users,  load average: 3.54, 1.99, 3.98
top - 15:14:28 up  1:26,  6 users,  load average: 4.99, 2.35, 4.07
top - 15:14:33 up  1:26,  6 users,  load average: 5.71, 2.55, 4.13
top - 15:14:39 up  1:26,  6 users,  load average: 5.90, 2.64, 4.15
top - 15:14:44 up  1:26,  6 users,  load average: 6.31, 2.77, 4.18
top - 15:14:49 up  1:26,  6 users,  load average: 6.20, 2.81, 4.19
top - 15:14:54 up  1:26,  6 users,  load average: 6.26, 2.88, 4.20
top - 15:14:59 up  1:26,  6 users,  load average: 6.00, 2.88, 4.20
top - 15:15:04 up  1:26,  6 users,  load average: 6.16, 2.97, 4.22
top - 15:15:09 up  1:26,  6 users,  load average: 5.91, 2.97, 4.21
top - 15:15:14 up  1:26,  6 users,  load average: 5.84, 3.00, 4.21
top - 15:15:19 up  1:27,  6 users,  load average: 5.93, 3.07, 4.23
top - 15:15:24 up  1:27,  6 users,  load average: 5.69, 3.07, 4.22
top - 15:15:29 up  1:27,  6 users,  load average: 6.12, 3.20, 4.26
top - 15:15:34 up  1:27,  6 users,  load average: 6.35, 3.29, 4.28
top - 15:15:39 up  1:27,  6 users,  load average: 6.72, 3.42, 4.32
top - 15:15:44 up  1:27,  6 users,  load average: 7.62, 3.66, 4.39
top - 15:15:49 up  1:27,  6 users,  load average: 8.29, 3.87, 4.45
top - 15:15:55 up  1:27,  6 users,  load average: 10.19, 4.33, 4.60
top - 15:16:00 up  1:27,  6 users,  load average: 10.10, 4.41, 4.62
top - 15:16:05 up  1:27,  6 users,  load average: 10.25, 4.54, 4.66
top - 15:16:10 up  1:27,  6 users,  load average: 10.07, 4.59, 4.68
top - 15:16:15 up  1:27,  6 users,  load average: 9.82, 4.63, 4.69
top - 15:16:20 up  1:28,  6 users,  load average: 9.60, 4.67, 4.71
top - 15:16:25 up  1:28,  6 users,  load average: 9.63, 4.76, 4.73
top - 15:16:30 up  1:28,  6 users,  load average: 9.66, 4.85, 4.76
top - 15:16:35 up  1:28,  6 users,  load average: 9.52, 4.90, 4.78
top - 15:16:40 up  1:28,  6 users,  load average: 9.16, 4.90, 4.78
top - 15:16:45 up  1:28,  6 users,  load average: 9.39, 5.02, 4.82
top - 15:16:50 up  1:28,  6 users,  load average: 9.12, 5.04, 4.83
top - 15:16:56 up  1:28,  6 users,  load average: 8.71, 5.02, 4.82
top - 15:17:01 up  1:28,  6 users,  load average: 8.25, 4.98, 4.81
top - 15:17:06 up  1:28,  6 users,  load average: 7.99, 4.98, 4.81
top - 15:17:11 up  1:28,  6 users,  load average: 7.75, 4.98, 4.81
top - 15:17:16 up  1:28,  6 users,  load average: 7.77, 5.03, 4.83
top - 15:17:21 up  1:29,  6 users,  load average: 7.79, 5.08, 4.85
top - 15:17:26 up  1:29,  6 users,  load average: 7.88, 5.15, 4.87
top - 15:17:31 up  1:29,  6 users,  load average: 8.05, 5.23, 4.89
top - 15:17:36 up  1:29,  6 users,  load average: 8.29, 5.32, 4.93
top - 15:17:41 up  1:29,  6 users,  load average: 8.51, 5.42, 4.96
top - 15:17:48 up  1:29,  6 users,  load average: 9.26, 5.68, 5.05
top - 15:17:53 up  1:29,  6 users,  load average: 9.48, 5.79, 5.09
top - 15:17:59 up  1:29,  6 users,  load average: 9.12, 5.77, 5.09
top - 15:18:04 up  1:29,  6 users,  load average: 8.63, 5.73, 5.08
top - 15:18:09 up  1:29,  6 users,  load average: 8.18, 5.68, 5.06
top - 15:18:14 up  1:29,  6 users,  load average: 8.01, 5.69, 5.07
top - 15:18:19 up  1:30,  6 users,  load average: 7.77, 5.68, 5.07
top - 15:18:24 up  1:30,  6 users,  load average: 7.62, 5.68, 5.07
top - 15:18:29 up  1:30,  6 users,  load average: 7.17, 5.62, 5.06
top - 15:18:34 up  1:30,  6 users,  load average: 6.84, 5.58, 5.05
top - 15:18:39 up  1:30,  6 users,  load average: 6.45, 5.52, 5.03
top - 15:18:44 up  1:30,  6 users,  load average: 6.17, 5.47, 5.02
top - 15:18:49 up  1:30,  6 users,  load average: 6.00, 5.45, 5.01
top - 15:18:54 up  1:30,  6 users,  load average: 6.24, 5.51, 5.03
top - 15:18:59 up  1:30,  6 users,  load average: 5.82, 5.43, 5.01
top - 15:19:04 up  1:30,  6 users,  load average: 5.67, 5.41, 5.01
top - 15:19:09 up  1:30,  6 users,  load average: 5.38, 5.35, 4.99
top - 15:19:14 up  1:30,  6 users,  load average: 5.11, 5.30, 4.97
top - 15:19:19 up  1:31,  6 users,  load average: 4.70, 5.21, 4.95
top - 15:19:24 up  1:31,  6 users,  load average: 4.48, 5.15, 4.93
top - 15:19:29 up  1:31,  6 users,  load average: 4.20, 5.08, 4.91
top - 15:19:34 up  1:31,  6 users,  load average: 3.95, 5.02, 4.89
top - 15:19:39 up  1:31,  6 users,  load average: 3.87, 4.98, 4.88
top - 15:19:44 up  1:31,  6 users,  load average: 3.64, 4.92, 4.86
top - 15:19:49 up  1:31,  6 users,  load average: 3.35, 4.83, 4.83
top - 15:19:54 up  1:31,  6 users,  load average: 3.16, 4.77, 4.81
top - 15:19:59 up  1:31,  6 users,  load average: 3.31, 4.77, 4.81
top - 15:20:04 up  1:31,  6 users,  load average: 3.28, 4.74, 4.80
top - 15:20:09 up  1:31,  6 users,  load average: 3.26, 4.72, 4.79
top - 15:20:15 up  1:31,  6 users,  load average: 3.00, 4.64, 4.76
top - 15:20:20 up  1:32,  6 users,  load average: 2.76, 4.56, 4.74
top - 15:20:25 up  1:32,  6 users,  load average: 2.70, 4.52, 4.72
top - 15:20:30 up  1:32,  6 users,  load average: 2.56, 4.46, 4.70
top - 15:20:35 up  1:32,  6 users,  load average: 2.36, 4.38, 4.68
top - 15:20:40 up  1:32,  6 users,  load average: 2.25, 4.33, 4.66
top - 15:20:45 up  1:32,  6 users,  load average: 2.07, 4.25, 4.63
top - 15:20:50 up  1:32,  6 users,  load average: 1.90, 4.18, 4.61
top - 15:20:55 up  1:32,  6 users,  load average: 1.91, 4.15, 4.59
top - 15:21:00 up  1:32,  6 users,  load average: 1.76, 4.08, 4.57
top - 15:21:05 up  1:32,  6 users,  load average: 1.69, 4.03, 4.55
top - 15:21:10 up  1:32,  6 users,  load average: 1.56, 3.96, 4.52
top - 15:21:15 up  1:32,  6 users,  load average: 1.43, 3.89, 4.50
top - 15:21:20 up  1:33,  6 users,  load average: 1.48, 3.86, 4.49
top - 15:21:25 up  1:33,  6 users,  load average: 2.24, 3.98, 4.52
top - 15:21:30 up  1:33,  6 users,  load average: 2.14, 3.93, 4.50
top - 15:21:35 up  1:33,  6 users,  load average: 2.85, 4.05, 4.54
top - 15:21:40 up  1:33,  6 users,  load average: 2.62, 3.98, 4.51
top - 15:21:45 up  1:33,  6 users,  load average: 2.41, 3.91, 4.49
top - 15:21:50 up  1:33,  6 users,  load average: 2.22, 3.85, 4.46
top - 15:21:55 up  1:33,  6 users,  load average: 2.04, 3.78, 4.44
top - 15:22:00 up  1:33,  6 users,  load average: 1.88, 3.72, 4.41
top - 15:22:05 up  1:33,  6 users,  load average: 1.73, 3.66, 4.39
top - 15:22:10 up  1:33,  6 users,  load average: 1.59, 3.60, 4.37
top - 15:22:15 up  1:33,  6 users,  load average: 1.46, 3.54, 4.34
top - 15:22:20 up  1:34,  6 users,  load average: 1.34, 3.48, 4.32
top - 15:22:25 up  1:34,  6 users,  load average: 1.24, 3.42, 4.30
top - 15:22:30 up  1:34,  6 users,  load average: 1.14, 3.36, 4.27
top - 15:22:35 up  1:34,  6 users,  load average: 1.04, 3.31, 4.25
top - 15:22:40 up  1:34,  6 users,  load average: 0.96, 3.25, 4.23
top - 15:22:45 up  1:34,  6 users,  load average: 0.88, 3.20, 4.20
top - 15:22:50 up  1:34,  6 users,  load average: 0.81, 3.15, 4.18
top - 15:22:55 up  1:34,  6 users,  load average: 0.75, 3.09, 4.16
top - 15:23:00 up  1:34,  6 users,  load average: 0.69, 3.04, 4.14
top - 15:23:05 up  1:34,  6 users,  load average: 0.63, 2.99, 4.11
top - 15:23:10 up  1:34,  6 users,  load average: 0.58, 2.94, 4.09
top - 15:23:15 up  1:34,  6 users,  load average: 0.53, 2.89, 4.07
top - 15:23:20 up  1:35,  6 users,  load average: 0.49, 2.84, 4.05
top - 15:23:25 up  1:35,  6 users,  load average: 0.45, 2.80, 4.02
top - 15:23:30 up  1:35,  6 users,  load average: 0.42, 2.75, 4.00
top - 15:23:35 up  1:35,  6 users,  load average: 0.38, 2.70, 3.98
top - 15:23:40 up  1:35,  6 users,  load average: 0.35, 2.66, 3.96
top - 15:23:45 up  1:35,  6 users,  load average: 0.32, 2.61, 3.94
top - 15:23:50 up  1:35,  6 users,  load average: 0.30, 2.57, 3.92
top - 15:23:55 up  1:35,  6 users,  load average: 0.27, 2.53, 3.89
top - 15:24:00 up  1:35,  6 users,  load average: 0.25, 2.49, 3.87
top - 15:24:05 up  1:35,  6 users,  load average: 0.23, 2.44, 3.85
top - 15:24:10 up  1:35,  6 users,  load average: 0.21, 2.40, 3.83
top - 15:24:15 up  1:35,  6 users,  load average: 0.19, 2.36, 3.81
top - 15:24:20 up  1:36,  6 users,  load average: 0.18, 2.32, 3.79
top - 15:24:25 up  1:36,  6 users,  load average: 0.16, 2.28, 3.77
top - 15:24:30 up  1:36,  6 users,  load average: 0.15, 2.25, 3.75
top - 15:24:35 up  1:36,  6 users,  load average: 0.14, 2.21, 3.73
top - 15:24:40 up  1:36,  6 users,  load average: 0.13, 2.17, 3.71
top - 15:24:45 up  1:36,  6 users,  load average: 0.12, 2.14, 3.69
top - 15:24:50 up  1:36,  6 users,  load average: 0.11, 2.10, 3.67
top - 15:24:55 up  1:36,  6 users,  load average: 0.10, 2.06, 3.65
top - 15:25:00 up  1:36,  6 users,  load average: 0.09, 2.03, 3.63
top - 15:25:05 up  1:36,  6 users,  load average: 0.08, 2.00, 3.61
top - 15:25:11 up  1:36,  6 users,  load average: 0.08, 1.96, 3.59
top - 15:25:16 up  1:36,  6 users,  load average: 0.07, 1.93, 3.57
top - 15:25:21 up  1:37,  6 users,  load average: 0.06, 1.90, 3.55
top - 15:25:26 up  1:37,  6 users,  load average: 0.06, 1.87, 3.53
top - 15:25:31 up  1:37,  6 users,  load average: 0.05, 1.83, 3.51
top - 15:25:36 up  1:37,  6 users,  load average: 0.05, 1.80, 3.49
top - 15:25:41 up  1:37,  6 users,  load average: 0.05, 1.77, 3.47
top - 15:25:46 up  1:37,  6 users,  load average: 0.04, 1.74, 3.45
top - 15:25:51 up  1:37,  6 users,  load average: 0.04, 1.71, 3.44
top - 15:25:56 up  1:37,  6 users,  load average: 0.03, 1.69, 3.42

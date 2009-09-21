Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbZIUHZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbZIUHZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbZIUHZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:25:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:55323 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751171AbZIUHZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:25:08 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+agXs2rT6aqfBiOEElfQBL74sIBP6HogRggw76HS
	XsoFQI7rQ8G3wD
Subject: Re: Poor desktop responsiveness with background I/O-operations
From: Mike Galbraith <efault@gmx.de>
To: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090920220405.GA395@duck.suse.cz>
References: <4AB59CBB.8090907@datenparkplatz.de>
	 <alpine.LRH.2.00.0909202221010.25928@twin.jikos.cz>
	 <20090920220405.GA395@duck.suse.cz>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 09:25:08 +0200
Message-Id: <1253517908.25640.37.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 00:04 +0200, Jan Kara wrote:
> On Sun 20-09-09 22:22:20, Jiri Kosina wrote:
> > On Sun, 20 Sep 2009, Ulrich Lukas wrote:
> > 
> > > Test case:
> > > - 64-bit dual-core PC, SATA harddrive, plenty of free RAM
> > > - vanilla Linux 2.6.31, Kubuntu 9.10 packages, all software 64-bit
> > > 
> > > 
> > > How to reproduce:
> > > - start KDE/GNOME-session
> > > - open a terminal window and do as a non-root user:
> > >   dd if=/dev/zero of=/home/john-doe/testfile
> > >   (or dd if=/home/john-doe/big-testfile of=/dev/null)
> > > 
> > > - a real use scenario would be a daily disk-backup or the
> > >   simple extraction of a tarball containing slightly bigger files
> > > 
> > > 
> > > Observation:
> > > - The system becomes _really_ slow as described above; unusable for
> > >   any multimedia tasks.
> > 
> > I guess that switching from CFQ to deadline I/O scheduler improves the 
> > situation, right?
>   For example on my desktop, switching to deadline slightly improves the
> situation but the machine is still mostly unusable while dd is running...
> I'll try to debug it some more to see whether it can be somehow helped.

Datapoint:

echo 1 > /sys/block/$disk/queue/iosched/quantum seems to make a huge
difference.  Stock is 4.  (wisdom of setting it to 1? no idea)

This...
marge:/root/tmp # ./testo.sh
quantum is 4, setting to 1
dd if=3DMark2000.mkv of=/tmp/3DMark2000.mkv
204529+1 records in
204529+1 records out
104718895 bytes (105 MB) copied, 1.62672 s, 64.4 MB/s
perf sched record -o /tmp/mplayer-c2-c2.data (tmpfs)&
mplayer /tmp/3DMark2000.mkv&
dd if=/dev/zero of=crud-25859&

sleep 180
timing konsole -e exit

 Performance counter stats for 'sh -c konsole -e exit':

     173.615837  task-clock-msecs         #      0.031 CPUs
            431  context-switches         #      0.002 M/sec
             10  CPU-migrations           #      0.000 M/sec
           6314  page-faults              #      0.036 M/sec
      368422027  cycles                   #   2122.053 M/sec
      376283291  instructions             #      1.021 IPC
        5883195  cache-references         #     33.886 M/sec
         444333  cache-misses             #      2.559 M/sec

    5.597628358  seconds time elapsed

...is pretty typical, and a LOT better than the 60-70 seconds I was
seeing, or the minutes I sometimes saw when playing with evolution.

I still occasionally see some largish numbers though, and suspect that
depends on how much cache was evicted.

	-Mike


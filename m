Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZITTim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZITTim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 15:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZITTim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 15:38:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:38662 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754197AbZITTil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 15:38:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/G7sdfvjnG1rRWcyuO+cGAkcSWfx6+jPMI3oYo1R
	Y619ZvoDPltGYO
Subject: Re: Poor desktop responsiveness with background I/O-operations
From: Mike Galbraith <efault@gmx.de>
To: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB5ECD0.7010903@datenparkplatz.de>
References: <4AB59CBB.8090907@datenparkplatz.de>
	 <20090920080728.73bfe2a1@infradead.org>
	 <4AB5ECD0.7010903@datenparkplatz.de>
Content-Type: multipart/mixed; boundary="=-uTr5PujV8rOSvqsQMLKY"
Date: Sun, 20 Sep 2009 21:38:41 +0200
Message-Id: <1253475521.9224.43.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uTr5PujV8rOSvqsQMLKY
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2009-09-20 at 10:50 +0200, Ulrich Lukas wrote:
> Arjan van de Ven wrote:
> > can you try the following two things?
> > 
> > echo 4096 > /sys/block/sda/queue/nr_requests
> > for i in `pidof kjournald` ; do ionice -c1 -p $i ; done
> 
> I tried this just now, but it doesn't change things much. I can do a
> more testing later today.

Try ionice -c3 for your dd.

> > I assume you're using CFQ.
> 
> Yes, it's CFQ. (see .config of my previous posting)
> 
> Filesystem is EXT4.

Mine is ext3.

I can easily reproduce pain.  The attached cheezy test script, when run
back to back with no args (stock IO), regularly produces beauties:

 Performance counter stats for 'sh -c konsole -e exit':

     257.670601  task-clock-msecs         #      0.004 CPUs
           1036  context-switches         #      0.004 M/sec
             30  CPU-migrations           #      0.000 M/sec
           6317  page-faults              #      0.025 M/sec
      471734719  cycles                   #   1830.767 M/sec
      393365060  instructions             #      0.834 IPC
        7849464  cache-references         #     30.463 M/sec
        1038976  cache-misses             #      4.032 M/sec

   65.766937233  seconds time elapsed

Yup, a full minute to get a binary loaded and fired up.  Seems it and
others get evicted by the VM.  Getting whatever back into ram is painful
to listen to (poor disk/me.. seek latency eating MUCH time).

Calling script back to back with args 1 (realtime foreground) 3 (idle
background) does best:

 Performance counter stats for 'sh -c konsole -e exit':

     169.915036  task-clock-msecs         #      0.077 CPUs
            439  context-switches         #      0.003 M/sec
              9  CPU-migrations           #      0.000 M/sec
           6314  page-faults              #      0.037 M/sec
      363128252  cycles                   #   2137.117 M/sec
      367410945  instructions             #      1.012 IPC
        5822302  cache-references         #     34.266 M/sec
         437189  cache-misses             #      2.573 M/sec

    2.213079979  seconds time elapsed

Args 2 (best effort foreground) and 3 (idle background);

 Performance counter stats for 'sh -c konsole -e exit':

     176.689856  task-clock-msecs         #      0.015 CPUs
            357  context-switches         #      0.002 M/sec
             15  CPU-migrations           #      0.000 M/sec
           6314  page-faults              #      0.036 M/sec
      374861947  cycles                   #   2121.582 M/sec
      368929476  instructions             #      0.984 IPC
        5806286  cache-references         #     32.861 M/sec
         496651  cache-misses             #      2.811 M/sec

   12.036165968  seconds time elapsed

	-Mike

--=-uTr5PujV8rOSvqsQMLKY
Content-Disposition: attachment; filename="testo.sh"
Content-Type: application/x-shellscript; name="testo.sh"
Content-Transfer-Encoding: 7bit

#!/bin/sh

FG=-c2
BG=-c2
TILT=0

if test $# -gt 0; then
        test $1 -eq 1 || test $1 -eq 2 || test $1 -eq 3 || TILT=1
        test $TILT -eq 0 && FG=-c$1 && FOREGROUND_IO="ionice $FG"
fi

if test $TILT -eq 0 && test $# -gt 1; then
        test $2 -eq 1 || test $2 -eq 2 || test $2 -eq 3 || TILT=1
        test $TILT -eq 0 && BG=-c$2 BACKGROUND_IO="ionice $BG"
fi

if test $TILT -eq 1; then
        echo "usage: testo.sh <foreground_class [0-3]> <background_class [0-3]>"
        exit;
fi

FILMCLIP=3DMark2000.mkv
LOGFILE=testo$FG$BG.log

$FOREGROUND_IO rm -f crud-$$

sh -c "echo $FOREGROUND_IO dd if=$FILMCLIP of=/tmp/$FILMCLIP" 2>&1|tee $LOGFILE
$FOREGROUND_IO dd if=$FILMCLIP of=/tmp/$FILMCLIP
sh -c "echo $BACKGROUND_IO perf sched record -o /tmp/mplayer$FG$BG.data \(tmpfs\)\&" 2>&1|tee -a $LOGFILE
$BACKGROUND_IO perf sched record -o /tmp/mplayer$FG$BG.data >/dev/null 2>&1&
sh -c "echo $FOREGROUND_IO mplayer /tmp/$FILMCLIP\&" 2>&1|tee -a $LOGFILE
$FOREGROUND_IO mplayer /tmp/$FILMCLIP >/dev/null 2>&1&
sh -c "echo $BACKGROUND_IO dd if=/dev/zero of=crud-$$\&" 2>&1|tee -a $LOGFILE
$BACKGROUND_IO dd if=/dev/zero of=crud-$$ >/dev/null 2>&1&
sh -c "echo " 2>&1|tee -a $LOGFILE

sh -c "echo sleep 180" 2>&1|tee -a $LOGFILE
sleep 180

sh -c  "echo timing konsole -e exit" 2>&1|tee -a $LOGFILE
perf stat -- sh -c "konsole -e exit" 2>&1|tee -a $LOGFILE
perf stat -- sh -c "konsole -e exit" 2>&1|tee -a $LOGFILE
perf stat -- sh -c "konsole -e exit" 2>&1|tee -a $LOGFILE

killall -qw perf dd mplayer
echo perf lat --sort=max|head -20|tee -a $LOGFILE
perf sched -i /tmp/mplayer$FG$BG.data lat --sort=max|head -20 2>&1|tee -a $LOGFILE

mv /tmp/mplayer$FG$BG.data .
rm /tmp/$FILMCLIP
rm -f crud-$$
sync

--=-uTr5PujV8rOSvqsQMLKY--


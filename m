Return-Path: <linux-kernel-owner+w=401wt.eu-S965861AbXDGOLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965861AbXDGOLt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 10:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965864AbXDGOLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 10:11:49 -0400
Received: from khc.piap.pl ([195.187.100.11]:45760 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965861AbXDGOLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 10:11:48 -0400
To: johnrobertbanks@fastmail.fm
Cc: "Jan Harkes" <jaharkes@cs.cmu.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
References: <46157B5B.5000602@gmail.com>
	<1175817921.18400.1183285196@webmail.messagingengine.com>
	<461592FB.5060507@zytor.com>
	<1175819681.20754.1183287946@webmail.messagingengine.com>
	<461596DE.2020802@zytor.com>
	<1175823288.25662.1183293506@webmail.messagingengine.com>
	<4615C780.5040407@zytor.com>
	<1175833931.8916.1183307802@webmail.messagingengine.com>
	<20070406152119.GC4228@delft.aura.cs.cmu.edu>
	<1175914056.9653.1183426876@webmail.messagingengine.com>
	<20070407033049.GI4228@delft.aura.cs.cmu.edu>
	<1175925525.21154.1183436614@webmail.messagingengine.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 07 Apr 2007 16:11:46 +0200
In-Reply-To: <1175925525.21154.1183436614@webmail.messagingengine.com> (johnrobertbanks@fastmail.fm's message of "Fri, 06 Apr 2007 22:58:45 -0700")
Message-ID: <m34pns46l9.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

johnrobertbanks@fastmail.fm writes:

> Why do you think I hate reiserfs developers? That is an insane claim.
> Why would I hate reiser3 developers?
> Why would I hate reiser4 developers? 
> Why would I even dislike them?
>
> I think Hans Reiser is a genius. Is that what you mean by hate?

I think they could hire a person with a bit better marketing skills,
though. People on a technical mailing list don't buy things just
because something on TV told them they have to.

> Answer this question. Why do YOU think I am antagonizing reiserfs
> developers?

That might be just a side effect.

> Think about it,... read speeds that are some FOUR times the physical
> disk read rate,... impossible without the use of compression (or
> something similar).

It's really impossible with compression only unless you're writing
only zeros or stuff alike. I don't know what bonnie uses for testing
but real life data doesn't compress 4 times. Two times, sometimes,
but then it will be typically slower than disk access (I mean read,
as write will be much slower).

You can get faster I/O (both linear speed and access times) using
multiple disks (mirrors etc). Perhaps some ZFS ideas would do us
some good?

Gzip - 3 files (zeros only, raw DV data from video camera, x86_64
kernel rpm file), 10 MB of data (10*1024*1024), done on tmpfs so no
real disk speed factor. The CPU is AMD64 with 1 MB cache per core,
2600 MHz clock (clock scaling disabled). That's my typical usage
pattern (well, not counting these zeros).

$ l -Ggh zeros dv bin
-rw-r--r-- 1 10M Apr  7 15:30 bin
-rw-r--r-- 1 10M Apr  7 15:31 dv
-rw-r--r-- 1 10M Apr  7 15:31 zeros

$ for f in zeros dv bin; do time gzip $f; done
real    0m0.112s
real    0m0.686s
real    0m0.559s

Dealing with pure zeros gzip can get almost 90 MB/s compressing, but
with DV and rpm it only does 14.5 and almost 18 MB/s respectively...

$ l -Ggh zeros.gz dv.gz bin.gz
-rw-r--r-- 1  10K Apr  7 15:31 zeros.gz
-rw-r--r-- 1 9.1M Apr  7 15:31 dv.gz
-rw-r--r-- 1 9.3M Apr  7 15:30 bin.gz

... and though the numbers may still sound impressive, space savings
are less than 10%.

$ for f in zeros dv bin; do time gunzip $f.gz; done
real    0m0.067s
real    0m0.131s
real    0m0.120s

Decompression gives 150 MB/s for zeros and ~ 80 MB/s for DV and rpm.

$ for f in zeros dv bin; do time gzip -1 $f; done
real    0m0.079s
real    0m0.572s
real    0m0.530s

Supposed to be "fastest gzip". 126 MB/s for zeros but still less than
19 MB/s for DV and rpm.

$ l -Ggh zeros.gz dv.gz bin.gz
-rw-r--r-- 1  45K Apr  7 15:31 zeros.gz
-rw-r--r-- 1 9.2M Apr  7 15:31 dv.gz
-rw-r--r-- 1 9.3M Apr  7 15:30 bin.gz

$ for f in zeros dv bin; do time gunzip $f.gz; done
real    0m0.044s
real    0m0.135s
real    0m0.120s

It seems gzip can decompress zeros with 227 MB/s rate.
I assume the "4x read speed" claim comes from something like this.

$ /sbin/hdparm -t /dev/sda

/dev/sda:
 Timing buffered disk reads:  210 MB in  3.02 seconds =  69.59 MB/sec

$ echo "69.59*4" | bc
278.36

Seems you'd need a faster algorithm, faster machine or slower disk
- slower than this cheap SATA with disabled NCQ (NV SATA) at least:

$ cat /sys/block/sda/device/model
Maxtor 6V250F0

Please note that aplication-level compression usually gives way
better results - the application knows much more.
-- 
Krzysztof Halasa

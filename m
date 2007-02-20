Return-Path: <linux-kernel-owner+w=401wt.eu-S1030394AbXBTVKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030394AbXBTVKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030386AbXBTVKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:10:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:46877 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030394AbXBTVKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:10:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,197,1170662400"; 
   d="scan'208"; a="184860016:sNHT24925908"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Date: Wed, 21 Feb 2007 00:09:58 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC871E37@mssmsx411>
In-Reply-To: <20070220175457.GS6133@think.oraclecorp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to completion event
Thread-Index: AcdVGHtkk5/wt/UuRv+7FcVBa/X3tAAFm3XQ
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Chris Mason" <chris.mason@oracle.com>
Cc: "Zach Brown" <zach.brown@oracle.com>, <linux-aio@kvack.org>,
       <linux-kernel@vger.kernel.org>, "Benjamin LaHaise" <bcrl@kvack.org>,
       "Suparna bhattacharya" <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 20 Feb 2007 21:10:02.0601 (UTC) FILETIME=[7CA1A590:01C75533]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-O I've missed:
aiostress -s 1200m -O -o 2 -i 1 -r 16k <test_file>

You are right I've used harness scripts.
i=0; while ((i++<50)); do ~/bm/bin/runs I2 -; done &

It runs bmrun harness script which is long for different hardware
configurations and test options.
The lines in aio-stress wrapper which could be useful for you are:
        gcc aiostress.c -Wall -o aiostress -lpthread -laio
2>>${file_log}
...
        sudo umount -f ${pdisk} ${ppath} > /dev/null 2>&1
        sudo /sbin/mke2fs -j ${pdisk} > /dev/null 2>>${file_log}
        sudo mount ${pdisk} ${ppath} > /dev/null 2>>${file_log}...
        export LD_LIBRARY_PATH=/lib:/usr/lib:$LD_LIBRARY_PATH
        all_files_size=1200             # in megabytes
...
        else
                num_disks=1
                ((file_size = all_files_size / num_disks))
                testfiles=${ppath}/test/testfile
                dd if=/dev/zero of=$testfiles bs=1M count=${file_size} >
/dev/null
        fi
        aiostress ${*} -v -o 2 -s ${file_size}m -i 1 -r 16k $testfiles >
${file_res} 2>&1
        if [ "$1" == "-S" ] ; then
                info="O_SYNC"
        elif [ "$1" == "-O" ] ; then
                info="O_DIRECT"
        fi
        awk .... ${file_res}
....
Which does 
1) mem=1G in kernel boot param if you have more
2) unmount; mk2fs; mount
3) dd if=/dev/zero of=<test_file> bs=1M count=1200
4) aiostress -s 1200m -O -o 2 -i 1 -r 16k <test_file>
5) if i++<50 goto 2).

Leonid
-----Original Message-----
From: Chris Mason [mailto:chris.mason@oracle.com] 
Sent: Tuesday, February 20, 2007 8:55 PM
To: Ananiev, Leonid I
Cc: Zach Brown; linux-aio@kvack.org; linux-kernel@vger.kernel.org;
Benjamin LaHaise; Suparna bhattacharya; Andrew Morton
Subject: Re: [PATCH 2/2] aio: propogate post-EIOCBQUEUED errors to
completion event

On Tue, Feb 20, 2007 at 08:17:51PM +0300, Ananiev, Leonid I wrote:
> aio-stress command lines used for test
> 1) mem=1G in kernel boot param if you have more
> 2) mk2fs for test_file
> 3) dd if=/dev/zero of=<test_file> bs=1M count=1200
> 4) aiostress -s 1200m -o 2 -i 1 -r 16k <test_file>
> 

Sorry, this aio-stress command line doesn't do O_DIRECT.  Do you have
this bundled into a test script that I can try?

-chris

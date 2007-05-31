Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbXEaAiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbXEaAiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbXEaAh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:37:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:41450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbXEaAh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:37:57 -0400
From: Neil Brown <neilb@suse.de>
To: Bill Davidsen <davidsen@tmr.com>
Date: Thu, 31 May 2007 10:37:31 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18014.6347.753050.606896@notabene.brown>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, linux-raid@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
In-Reply-To: message from Bill Davidsen on Monday May 28
References: <18006.38689.818186.221707@notabene.brown>
	<465AEAA5.7000407@tmr.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday May 28, davidsen@tmr.com wrote:
> There are two things I'm not sure you covered.
> 
> First, disks which don't support flush but do have a "cache dirty" 
> status bit you can poll at times like shutdown. If there are no drivers 
> which support these, it can be ignored.

There are really devices like that?  So to implement a flush, you have
to stop sending writes and wait and poll - maybe poll every
millisecond?
That wouldn't be very good for performance....  maybe you just
wouldn't bother with barriers on that sort of device?

Which reminds me:  What is the best way to turn off barriers?
Several filesystems have "-o nobarriers" or "-o barriers=0",
or the inverse.
md/raid currently uses barriers to write metadata, and there is no
way to turn that off.  I'm beginning to wonder if that is best.

Maybe barrier support should be a function of the device.  i.e. the
filesystem or whatever always sends barrier requests where it thinks
it is appropriate, and the block device tries to honour them to the
best of its ability, but if you run
   blockdev --enforce-barriers=no /dev/sda
then you lose some reliability guarantees, but gain some throughput (a
bit like the 'async' export option for nfsd).

> 
> Second, NAS (including nbd?). Is there enough information to handle this 
> "really rigt?"

NAS means lots of things, including NFS and CIFS where this doesn't
apply.
For 'nbd', it is entirely up to the protocol.  If the protocol allows
a barrier flag to be sent to the server, then barriers should just
work.  If it doesn't, then either the server disables write-back
caching, or flushes every request, or you lose all barrier
guarantees. 
For 'iscsi', I guess it works just the same as SCSI...

NeilBrown

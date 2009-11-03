Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbZKCP1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbZKCP1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbZKCP1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:27:47 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:43688 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbZKCP1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:27:44 -0500
Date: Tue, 3 Nov 2009 10:26:51 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Sage Weil <sage@newdream.net>
Cc: linux-btrfs@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: ext3/jbd oops in journal_start
Message-ID: <20091103152651.GA14967@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <Pine.LNX.4.64.0910302253100.1867@cobra.newdream.net>
 <87bpjorn6g.fsf@openvz.org>
 <Pine.LNX.4.64.0911022157360.26157@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911022157360.26157@cobra.newdream.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AF04BEF.00C2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 10:06:36PM -0800, Sage Weil wrote:
> On Sat, 31 Oct 2009, Dmitry Monakhov wrote:
> 
> > Sage Weil <sage@newdream.net> writes:
> > 
> > > Hi,
> > >
> > > I'm consistently seeing ext3 oops on a fresh ~60 GB fs on 2.6.32-rc3 (and 
> > > 2.6.31).  data=writeback or data=ordered.  It's not the hardware or 
> > > drive... I have 8 boxes (each with slightly different hardware) that crash 
> > > identically.
> > Strange, 2.6.31 with ext3 is quite popular configuration...
> > Can you please post exact test-case.
> > >
> > > The oops is at fs/jbd/transaction.c, journal_start():
> > >
> > > 		J_ASSERT(handle->h_transaction->t_journal == journal);
> > *handle = journal_current_handle()
> > 
> > IMHO it's looks like you have entered here with current->journal_info != NULL
> > 
> > , but journal_info contains unexpected data
> > This may happens in two cases:
> > 1) calling jbd code from other filesystem.
> > 2) Some fs forget to zero current->journal_info on exit from vfs
> > According to call trace we have got second case. Do you use some 
> > unusual/experimental fs?
> 
> Yep, it was #2.  It turns out btrfs s setting current->journal_info 
> (for no reason that I can see?), and with the transaction ioctl a 
> transaction can span multiple calls.
> 
> Chris, is it ok to just remove the journal_info bits?  Nothing in fs/btrfs 
> even looks at it.  I'm not sure what the point of only conditionally 
> setting/clearly journal_info would be either, unless it's for debugging or 
> something?

Josef has plans to use it later on, but he sent along patches that will
avoid setting journal_info for userland trans.  I'll get these
integrated and pushed out.

-chris


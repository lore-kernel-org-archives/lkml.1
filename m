Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbXFPDr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbXFPDr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 23:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbXFPDrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 23:47:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbXFPDrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 23:47:17 -0400
From: Neil Brown <neilb@suse.de>
To: Wakko Warner <wakko@animx.eu.org>
Date: Sat, 16 Jun 2007 13:47:07 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18035.23867.576212.859440@notabene.brown>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: message from Wakko Warner on Friday June 15
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<20070616020320.GB2002@animx.eu.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday June 15, wakko@animx.eu.org wrote:
 
>                                                   As I understand the way
> raid works, when you write a block to the array, it will have to read all
> the other blocks in the stripe and recalculate the parity and write it out.

Your understanding is incomplete.
For raid5 on an array with more than 3 drive, if you attempt to write
a single block, it will:

 - read the current value of the block, and the parity block.
 - "subtract" the old value of the block from the parity, and "add"
   the new value.
 - write out the new data and the new parity.

If the parity was wrong before, it will still be wrong.  If you then
lose a drive, you lose your data.

With the current implementation in md, this only affect RAID5.  RAID6
will always behave as you describe.  But I don't promise that won't
change with time.

It would be possible to have a 'this is not initialised' flag on the
array, and if that is not set, always do a reconstruct-write rather
than a read-modify-write.  But the first time you have an unclean
shutdown you are going to resync all the parity anyway (unless you
have a bitmap....) so you may as well resync at the start.

And why is it such a big deal anyway?  The initial resync doesn't stop
you from using the array.  I guess if you wanted to put an array into
production instantly and couldn't afford any slowdown due to resync,
then you might want to skip the initial resync.... but is that really
likely?

NeilBrown

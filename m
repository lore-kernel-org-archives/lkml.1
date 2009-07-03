Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbZGCWy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbZGCWy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 18:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbZGCWyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 18:54:20 -0400
Received: from complete.lackof.org ([198.49.126.79]:32839 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbZGCWyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 18:54:20 -0400
Date: Fri, 3 Jul 2009 16:54:22 -0600
From: dann frazier <dannf@dannf.org>
To: Stephen Frost <sfrost@snowman.net>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, David Altobelli <david.altobelli@hp.com>,
       nagananda.chumbalkar@hp.com
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090703225422.GB18235@lackof.org>
References: <20090628172052.GA13957@ldl.fc.hp.com> <20090628223258.GP20436@tamriel.snowman.net> <20090630011541.GL22480@ldl.fc.hp.com> <20090630011709.GT20436@tamriel.snowman.net> <86802c440906291847p302d47eau1d1cbd07be59c61@mail.gmail.com> <20090630015140.GV20436@tamriel.snowman.net> <20090630015302.GN22480@ldl.fc.hp.com> <20090630020644.GW20436@tamriel.snowman.net> <20090630193050.GA9496@lackof.org> <20090701013504.GE20436@tamriel.snowman.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701013504.GE20436@tamriel.snowman.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 09:35:04PM -0400, Stephen Frost wrote:
> * dann frazier (dannf@dannf.org) wrote:
> > On Mon, Jun 29, 2009 at 10:06:44PM -0400, Stephen Frost wrote:
> > > Don't suppose you can grab a P600 from somewhere and try?
> > 
> > Got one, and I am able to reproduce a hang while initializing
> > cciss. I'll try narrowing down the issue.
> 
> Great!  Glad to hear it.  If there's anything I can do to help, please
> let me know.

Here's what I've found.

Bisecting the hang lands on this commit, which went in right before
2.6.26 went final:

  77b96bd: cciss: fix regression that no device nodes are created
           if no logical drives

This seems to have caused problems for 2.6.26 era kernels (including
Debian's current stable release). I'm not sure if this problem still
exists in 2.6.31-rc1, because I think we are hitting an earlier issue
which also manifests as a hang.

In 2.6.31-rc1, I see a hang while trying to request the firmware
version using sendcmd_withirq(). If I switch this to a sendcmd(), it
proceeds until the next sendcmd_withirq(). /proc/interrupts shows a 0
count for all cpus on the chosen IRQ line (26). This makes me wonder
if its related to the issue:
  http://www.spinics.net/lists/linux-scsi/msg37177.html

-- 
dann frazier


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbXHUSXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbXHUSXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761521AbXHUSXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:23:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42854 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758393AbXHUSXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:23:08 -0400
From: Jonathan Lim <jlim@sgi.com>
Message-Id: <200708211824.l7LIO10g379050@sabah.engr.sgi.com>
Subject: Re: [PATCH] Send exit code through for taskstats.ac_exitcode
To: balbir@linux.vnet.ibm.com
Date: Tue, 21 Aug 2007 11:24:01 -0700 (PDT)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46CA5F8D.20104@linux.vnet.ibm.com> from "Balbir Singh" at Aug 21, 2007 09:14:13 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon Aug 20 20:44:13 2007, balbir@linux.vnet.ibm.com wrote:
> 
> Jonathan Lim wrote:
> > taskstats.ac_exitcode is assigned to task_struct.exit_code in
> > bacct_add_tsk() through the following kernel function calls: 
> > 
> >   do_exit()
> >     taskstats_exit_send()
> >       fill_pid()
> >         bacct_add_tsk()
> > 
> > The problem is that in do_exit(), task_struct.exit_code is set to 'code' 
> > only after taskstats_exit_send() has been called.  So we need to send
> > 'code' through to bacct_add_tsk().
> 
> Hi, Jonathan,
> 
> The patches look like a step in the right direction, I would suggest an
> alternate implementation
> 
> Why can't we assign tsk->exit_code to code earlier? Can we not move up the
> assignment to before taskstats_exit()? Wouldn't that be much simpler?

Hi Balbir,

That was what I wanted to do at first, but there was some concern over whether
it would affect any of the intervening function calls.  If there's no
particular reason why the tsk->exit_code assignment is placed where it's at
now, then yes, I would much rather move it to before taskstats_exit().

I looked at the following functions involving tsk:

  exit_mm
    mm_release
      deactivate_mm
  exit_sem
  __exit_files
  __exit_fs
  cpuset_exit
  exit_keys

and don't see anything that setting exit_code would affect.  What do you think?

Jonathan

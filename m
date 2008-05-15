Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbYEOUur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbYEOUur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbYEOUuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:50:21 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44778 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbYEOUuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:50:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Huang, Ying" <ying.huang@intel.com>, <nigel@nigel.suspend2.net>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>
References: <Pine.LNX.4.44L0.0805151012150.2107-100000@iolanthe.rowland.org>
Date: Thu, 15 May 2008 13:48:14 -0700
In-Reply-To: <Pine.LNX.4.44L0.0805151012150.2107-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Thu, 15 May 2008 10:14:00 -0400 (EDT)")
Message-ID: <m18wybqooh.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;_HEADER(TO)
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Wed, 14 May 2008, Eric W. Biederman wrote:
>
>> My take on the situation is this.  For proper handling we
>> need driver device_detach and device_reattach methods.
>> 
>> With the following semantics.  The device_detach methods
>> will disable DMA and place the hardware in a sane state
>> from which the device driver can reclaim and reinitialize it,
>> but the hardware will not be touched.
>> 
>> device_reattach reattaches the driver to the hardware.
>
> How would these differ from the already-existing remove and probe 
> methods?

Honestly I would like for them not to, and they should be
proper factors of the remove and probe methods.

However we have a fundamental gotcha that we need to handle.
Logical abstractions on physical devices.

i.e.  How do we handle the case of a filesystem on a block
      device, when we remove the block device and then read it.

We have two choices.
1) We go through the pain of teaching the upper layers in the
   kernel of how to deal with hotplug and then we are sane
   when someone removes a usb stick accidentally before
   unmounting it and then reinserts the usb stick.

2) Teach the drivers how to do just the lower have of hotplug/remove.
   In which case with the driver still present and presenting it's
   upper layer queues we have the driver relinquish it's hardware
   and then later check to see if it's hardware is still present
   and reinitialize it.

I don't know if anyone has looked at moving this to an upper layer.
Definitely a question worth asking.  The simpler we can make this
for driver authors the better.  Especially as that will make
the drivers more maintainable long term.

Eric

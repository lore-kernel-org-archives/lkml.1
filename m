Return-Path: <linux-kernel-owner+w=401wt.eu-S1762506AbYFESfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762506AbYFESfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759327AbYFESfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:35:37 -0400
Received: from sous-sol.org ([216.99.217.87]:44602 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720AbYFESfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:35:14 -0400
Date: Thu, 5 Jun 2008 11:34:47 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Roedel, Joerg" <Joerg.Roedel@amd.com>
Subject: Re: kvm: unable to handle kernel NULL pointer dereference
Message-ID: <20080605183447.GL30402@sequoia.sous-sol.org>
References: <20080601084802.GA3146@yamamaya.is-a-geek.org> <4846716E.5000506@qumranet.com> <20080604181019.GB10897@yamamaya.is-a-geek.org> <20080605042535.GC30402@sequoia.sous-sol.org> <20080605060931.GA11704@yamamaya.is-a-geek.org> <20080605072728.GF30402@sequoia.sous-sol.org> <20080605182847.GA12176@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605182847.GA12176@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tobias Diedrich (ranma+kernel@tdiedrich.de) wrote:
> PM: Creating hibernation image: 
> PM: Need to copy 126181 pages
> PM: Normal pages needed: 126181 + 1024 + 38, available pages: 397721
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> svm_cpu_init: svm_data is NULL on 0

Yeah, this is broken.  What happens is:

suspend:
  hardware_disable
    svm_hardware_disable
      kfree(svm_data)
      per_cpu(svm_data) = NULL

resume:
  hardware_enable
    svm_hardware_enable
      if(!svm_data) printk("svm_cpu_init: svm_data is NULL on 0")

at this point it is broken.

Same would happen on an SMP box by simply doing offline/online of a CPU.
This is definitely busted, looking into a patch.

thanks,
-chris

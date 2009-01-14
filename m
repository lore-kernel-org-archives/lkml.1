Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbZANLoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbZANLoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbZANLoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:44:16 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:2337 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758965AbZANLoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:44:14 -0500
X-BigFish: VPS-39(zz1432R98dR1805M179dR936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KDGLXE-03-0J0-01
Date: Wed, 14 Jan 2009 12:44:01 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, dwmw2@infradead.org,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 08/16] dma-debug: add core checking functions
Message-ID: <20090114114401.GL20283@amd.com>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-9-git-send-email-joerg.roedel@amd.com> <20090110231127.GK17917@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090110231127.GK17917@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 14 Jan 2009 11:44:02.0004 (UTC) FILETIME=[65384940:01C9763D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 12:11:27AM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > +#define err_printk(dev, format, arg...) do {			\
> > +		error_count += 1;				\
> > +		if (show_all_errors || show_num_errors > 0) {	\
> > +			WARN(1, "%s %s: " format,		\
> > +			     dev_driver_string(dev),		\
> > +			     dev_name(dev) , ## arg);		\
> > +		}						\
> > +		if (!show_all_errors && show_num_errors > 0)	\
> > +			show_num_errors -= 1;			\
> 
> Note that the arithmetics here is SMP-unsafe: we only hold the hash bucket 
> so if two errors hit at once on two CPUs then the error tracking variables 
> can be accessed at once.
> 
> I'd suggest a simple global lock for this error case (taken inside the 
> hash bucket lock), to be on the safe side.

As I wrote in a previous email, a race here is no big deal. I add a
comment to document it. Or do we want another global lock here?

> Also, please dont use a macro for this - printk details can be passed in 
> to helper inlines/functions too.

Hmm, how does this look like? There is not WARN variant which can use
va_args as a parameter. And it is important that the error message is
logged in the warning itself. So the driver developer can see it when a
user reports the warning.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632


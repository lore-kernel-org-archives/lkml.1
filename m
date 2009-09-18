Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbZIRR24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbZIRR24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbZIRR24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:28:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58979 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206AbZIRR2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:28:55 -0400
Subject: Re: [Patch] AMD64_EDAC: Fix amd64_map_to_dcs_mask
From: Keith Mannthey <kmannth@us.ibm.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: lkml <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
In-Reply-To: <20090918144226.GD25309@aftab>
References: <1253239781.7263.113.camel@keith-laptop>
	 <20090918144226.GD25309@aftab>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 10:28:53 -0700
Message-Id: <1253294933.7263.129.camel@keith-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 16:42 +0200, Borislav Petkov wrote:
> On Thu, Sep 17, 2009 at 07:09:41PM -0700, Keith Mannthey wrote:

<snip>

> >  /* Map from a CSROW entry to the mask entry that operates on it */
> >  static inline u32 amd64_map_to_dcs_mask(struct amd64_pvt *pvt, int csrow)
> >  {
> > -	return csrow >> (pvt->num_dcsm >> 3);
> > +	return csrow >> (8 >> (ilog2(pvt->num_dcsm)+1));
> 
> Almost. You have 8 DCSMs on RevE, 4 on RevF and F10h and 2 on F11h and
> this way you get wrong DCSM offsets for F11h. A dirty fix would be:

I think this will still be ok for F11. 


ilog2(2) = 1 

1 + 1 == 2 

8 >> 2 == 2 

csrow >> 2 

This would be ok rev F11 assuming 8 total. 

Am I missing something else? 

> if (boot_cpu_data.x86 == 0xf && pvt->ext_model < OPTERON_CPU_REV_E) {
> 	return csrow;
> else
> 	return csrow >> 1;

Still busted for F11. 

> The problem is, the csrow thing still goes over 0..7 which is obviously
> wrong on F11h but I'll fix that later. Care to redo your patch according
> to these and the comments from my previous mail and resend?

Are there more than 8 csrows any any version (I don't currently have F11
specs).  Maybe should just move to a map rather than a math trick to get
to the right index? 


> By the way, your patches made me look harder at that code region and
> I've found some more problems with it which I've fixed. Would you like
> to test the whole bunch of fixes on your setup?

Yes please send any changes you have.  I have a decent test setup for
live errors. 

Thanks,
  Keith 


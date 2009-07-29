Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZG2NGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZG2NGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZG2NGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:06:18 -0400
Received: from nox.protox.org ([88.191.38.29]:37170 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbZG2NGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:06:17 -0400
Subject: Re: ttm_mem_global
From: Jerome Glisse <glisse@freedesktop.org>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <4A7018DA.807@shipmail.org>
References: <1245931298.13359.8.camel@localhost.localdomain>
	 <4A439D7D.9030401@shipmail.org>  <1248197676.2368.11.camel@localhost>
	 <1248199231.2368.17.camel@localhost> <1248204128.2368.20.camel@localhost>
	 <4A66CFDE.9090705@shipmail.org> <1248799724.2288.11.camel@localhost>
	 <4A6F498E.8090601@shipmail.org> <1248857973.2426.6.camel@localhost>
	 <4A7018DA.807@shipmail.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jul 2009 15:04:51 +0200
Message-Id: <1248872692.2886.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 11:39 +0200, Thomas Hellström wrote:
> Jerome Glisse wrote:
> > On Tue, 2009-07-28 at 20:55 +0200, Thomas Hellström wrote:
> >   
> >> Jerome Glisse skrev:
> >>     
> >>> On Wed, 2009-07-22 at 10:37 +0200, Thomas Hellström wrote:
> >>>   
> >>>       
> >>>> TTM has a device struct per device and an optional global struct that is 
> >>>> common for all devices and intended to be per subsystem.
> >>>>
> >>>> The only subsystem currently having a global structure is the memory 
> >>>> accounting subsystem:
> >>>> struct ttm_mem_global
> >>>>     
> >>>>         
> >>> Thomas i don't think the way we init ttm_mem_global today make
> >>> it follow the 1 struct ttm_mem_global for everyone. I think it
> >>> should be initialized and refcounted by device struct.
> >>>
> >>> So on first device creation a ttm_mem_global is created and
> >>> then anytime a new device is created the refcount of ttm_mem_global
> >>> is increased. 
> >>>       
> >> Jerome,
> >> This is exactly what the current code intends to do.
> >>
> >> Are you seeing something different?
> >>     
> >
> > I definitly don't see that :) In radeon we do create a structure
> > which hold the ttm_mem_global struct so it's not shared at all
> > it got inited & destroyed along the driver. This is why i think
> > it's better to remove the driver initialization and let bo_device
> > init path take care of initializing one and only one object which
> > can be shared by multiple driverttm_mem_global_inits.
> >
> >   
> Which radeon struct is holding the ttm_mem_global struct?
> 
> The radeon code looks very similar to the openchrome code in which the 
> struct ttm_mem_global is allocated at ttm_global.c, line 74 and freed at 
> ttm_global.c, line 108 when its refcount has reached zero.
> 
> So the device holds a struct ttm_global_reference that *only points* to 
> the global item, and which is destroyed on device takedown. If there are 
> more than one device pointing to the mem_global object, it won't get 
> destroyed.
> 
> So the code should be working perfectly fine unless there is a bug.
> 
> > So what i propose is remove mem_glob parameter from :
> > ttm_bo_device_init, add a call to ttm_mem_global_init in
> > ttm_bo_device_init 
> 
> Nope, The ttm_mem_global object is used by other  ttm subsystems 
> (fencing, user-space objects),
> so that can't be done.
> 
> > and add some static refcount in ttm_memory.c
> > if refcount = 0 then ttm_mem_global_init create a ttm_mem_global
> > struct and initialize things, if refcount > 0 then it gives
> > back the already initialized ttm_mem_global.
> >
> >   
> 
> This is exactly what ttm_global was created to do, and what it hopefully 
> does. If you create two radeon devices the ttm_mem_global object should 
> be the same, even though the global references pointing to it are of 
> course different. Have you actually tried this?
> 
> /Thomas
> 

Ok code wasn't clear for me until i read ttm_global.c

Cheers,
Jerome


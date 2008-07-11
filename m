Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbYGKBjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbYGKBjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYGKBj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:39:27 -0400
Received: from relay2.sgi.com ([192.48.171.30]:44236 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751962AbYGKBj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:39:27 -0400
Message-ID: <4876B9CD.6080802@sgi.com>
Date: Thu, 10 Jul 2008 18:39:25 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org>	<m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com>	<487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org>	<48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org>	<48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org>	<m1prpl4pmh.fsf@frodo.ebiederm.org> <48764C21.4020601@zytor.com>	<m1fxqhzhcu.fsf@frodo.ebiederm.org> <4876608B.10408@sgi.com> <m1zloptrwt.fsf@frodo.ebiederm.org>
In-Reply-To: <m1zloptrwt.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Mike Travis <travis@sgi.com> writes:
> 
> 
>> The biggest growth came from moving all the xxx[NR_CPUS] arrays into
>> the per cpu area.  So you free up a huge amount of unused memory when
>> the NR_CPUS count starts getting into the ozone layer.  4k now, 16k
>> real soon now, ??? future?
> 
> Hmm.  Do you know how big a role kernel_stat plays.
> 
> It is a per cpu structure that is sized via NR_IRQS.  NR_IRQS is by NR_CPUS.
> So ultimately the amount of memory take up is NR_CPUS*NR_CPUS*32 or so.
> 
> I have a patch I wrote long ago, that addresses that specific nasty configuration
> by moving the per cpu irq counters into pointer available from struct irq_desc.
> 
> The next step which I did not get to (but is interesting from a scaling perspective)
> was to start dynamically allocating the irq structures.
> 
> Eric

If you could dig that up, that would be great.  Another engr here at SGI
took that task off my hands and he's been able to do a few things to reduce
the "# irqs" but irq_desc is still one of the bigger static arrays (>256k).

(There was some discussion a while back on this very subject.)

The top data users are:

====== Data (-l 500)
    1 - ingo-test-0701-256
    2 - 4k-defconfig
    3 - ingo-test-0701

      .1.      .2.      .3.    ..final..
  1048576  -917504  +917504 1048576      .  __log_buf(.bss)
   262144  -262144  +262144  262144      .  gl_hash_table(.bss)
   122360  -122360  +122360  122360      .  g_bitstream(.data)
   119756  -119756  +119756  119756      .  init_data(.rodata)
    89760   -89760   +89760   89760      .  o2net_nodes(.bss)
    76800   -76800  +614400  614400  +700%  early_node_map(.data)
    44548   -44548   +44548   44548      .  typhoon_firmware_image(.rodata)
    43008  +215040        .  258048  +500%  irq_desc(.data.cacheline_aligned)
    42768   -42768   +42768   42768      .  s_firmLoad(.data)
    41184   -41184   +41184   41184      .  saa7134_boards(.data)
    38912   -38912   +38912   38912      .  dabusb(.bss)
    34804   -34804   +34804   34804      .  g_Firmware(.data)
    32768   -32768   +32768   32768      .  read_buffers(.bss)
    19968   -19968  +159744  159744  +700%  initkmem_list3(.init.data)
    18041   -18041   +18041   18041      .  OperationalCodeImage_GEN1(.data)
    16507   -16507   +16507   16507      .  OperationalCodeImage_GEN2(.data)
    16464   -16464   +16464   16464      .  ipw_geos(.rodata)
    16388  +114688  -114688   16388      .  map_pid_to_cmdline(.bss)
    16384   -16384   +16384   16384      .  gl_hash_locks(.bss)
    16384  +245760        .  262144 +1500%  boot_pageset(.bss)
    16128  +215040        .  231168 +1333%  irq_cfg(.data.read_mostly)


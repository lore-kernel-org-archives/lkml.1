Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbYKVLSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbYKVLSp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 06:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbYKVLSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 06:18:36 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:56733 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbYKVLSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 06:18:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4927EA7D.7090003@s5r6.in-berlin.de>
Date: Sat, 22 Nov 2008 12:18:21 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20081027 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [RFC-PATCH] ieee1394: endian annotations of drivers/ieee1394
References: <1226514321.16649.7.camel@brick> <491B2309.1090900@s5r6.in-berlin.de>
In-Reply-To: <491B2309.1090900@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Harvey Harrison wrote:
>> Annotations are mostly trivial, quadlet_t -> __be32, octlet_t -> __be64
>> which will have no effect on compiled code.
> 
> I haven't looked at it yet but have point out one important thing:
> This is one of the many issues in drivers/ieee1394 which have already
> been fixed by introducing drivers/firewire.  I appreciate the work which
> you put into this, but I don't know yet if we want to take it in.

I test-applied and test-compiled it on x86-32 now.  There are still a
number of warnings from sparse after applying it:

  - in the ieee1394 core's transaction code, among else due to how
    packet headers are handled by the core and the low-level drivers,

  - in ohci1394, when accessing self-IDs and DMA programs,

  - in raw1394 when dealing with userspace data,

  - in eth1394, e.g. due to in-place endian conversions and because
    eth1394 uses bitfield datatypes for on-the-wire data.

I don't think that any of those are exceedingly difficult to fix, but
they are not entirely trivial, require time for development, testing and
review, and bring a risk of regressions.

As long as not *all* endianess related warnings from sparse go away in
drivers/ieee1394/, there is no benefit from starting with endianess
annotations in drivers/ieee1394/ in the first place.  Because there is
already a way to compile an IEEE 1394 capable Linux kernel which is
sparse-clean:

	CONFIG_FIREWIRE=m
	# CONFIG_IEEE1394 is not set

So, our time should better be spent on fixing up drivers/firewire/ to
make it the full replacement of drivers/ieee1394/ which it is intended
to be, see http://ieee1394.wiki.kernel.org/index.php/Juju_Migration and
http://ieee1394.wiki.kernel.org/index.php/To_Do .


Nevertheless, some comments to this patch:

>> Changed the protoypes of the read_regs, write_regs, lock_regs, lock64_regs
>> to take BE values rather than quadlet/octlet...propagated this through
>> helper functions.

More changes like this (comparably simple) in-kernel API change would be
required to finish the work.

>> csr.c: work directly with the BE values in the lock functions and only
>> convert to cpu-endian on demand, this part is non-trivial, but pretty
>> easy to verify.  Introduce a few temporary variables to make in clear
>> we are in cpu-endianness in a few cases.  Also, remove a few macros
>> that were used only once and obscured what was actually happening when
>> setting the type and generation...this eliminated some gratuitous
>> byteswapping back and forth between cpu and big endian.

OK, although these temporary variables aren't exactly beautiful.

It could be that switching more of the csr.h::struct csr_control members
to big endian would result in nicer code.

>> sbp.c: Eliminate the in-place be32-to-cpu inline which was only used once
>> and do the conversion once in the places where each struct member is set/read,
>> this propagates into one helper function that also now works directly in
>> be32.
>>
>> Also eliminate a few of the calls to the cpu-to-be32 that swapped a constant
>> 8 bytes and set the struct members directly as be32 values.

OK.  Incidentally, these are fine examples of "already fixed in
drivers/firewire/fw-sbp2.c".

>> dv1394.c is the only place where a change in behavior is intentional, the
>> setting of the flags is done as cpu-endian where everwhere else it is done
>> as little-endian, see the potion of the diff in ir_tasklet_func()

An endianess bug fix would have to be done as a separate patch.

>> The rest of the changes end up being pretty simple annotations of struct
>> members that were always treated as a particular endianness, mark them as
>> such.
>>
>> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>> ---
>>  drivers/ieee1394/csr.c                   |  148 ++++++++++++++++--------------
>>  drivers/ieee1394/csr.h                   |   14 ++--
>>  drivers/ieee1394/csr1212.c               |   55 +++++-------
>>  drivers/ieee1394/csr1212.h               |   14 ++--
>>  drivers/ieee1394/dv1394-private.h        |   44 +++++-----
>>  drivers/ieee1394/dv1394.c                |   12 +-
>>  drivers/ieee1394/eth1394.c               |   30 +++---
>>  drivers/ieee1394/eth1394.h               |   12 +-
>>  drivers/ieee1394/highlevel.c             |    8 +-
>>  drivers/ieee1394/highlevel.h             |   20 ++--
>>  drivers/ieee1394/hosts.c                 |    4 +-
>>  drivers/ieee1394/hosts.h                 |    2 +-
>>  drivers/ieee1394/ieee1394_core.h         |    2 +-
>>  drivers/ieee1394/ieee1394_transactions.c |    8 +-
>>  drivers/ieee1394/ieee1394_transactions.h |    6 +-
>>  drivers/ieee1394/nodemgr.c               |   14 ++--
>>  drivers/ieee1394/nodemgr.h               |    2 +-
>>  drivers/ieee1394/ohci1394.c              |    2 +-
>>  drivers/ieee1394/ohci1394.h              |    8 +-
>>  drivers/ieee1394/pcilynx.h               |    2 +-
>>  drivers/ieee1394/raw1394.c               |   42 ++++----
>>  drivers/ieee1394/sbp2.c                  |  119 ++++++++++--------------
>>  drivers/ieee1394/sbp2.h                  |   10 +-
>>  drivers/ieee1394/video1394.c             |    2 +-
>>  24 files changed, 278 insertions(+), 302 deletions(-)
>>
[...]
>> --- a/drivers/ieee1394/ieee1394_core.h
>> +++ b/drivers/ieee1394/ieee1394_core.h
>> @@ -69,7 +69,7 @@ struct hpsb_packet {
>>  	size_t header_size;		/* as filled in, not counting the CRC */
>>  
>>  	/* Buffers */
>> -	quadlet_t *data;		/* can be DMA-mapped */
>> +	__be32 *data;		/* can be DMA-mapped */
>>  	quadlet_t header[5];
>>  	quadlet_t embedded_data[0];	/* keep as last member */
>>  };

__be32 embedded_data[0];

[...]
>> --- a/drivers/ieee1394/ieee1394_transactions.c
>> +++ b/drivers/ieee1394/ieee1394_transactions.c
>> @@ -60,7 +60,7 @@ static void fill_async_readblock(struct hpsb_packet *packet, u64 addr,
>>  }
>>  
>>  static void fill_async_writequad(struct hpsb_packet *packet, u64 addr,
>> -				 quadlet_t data)
>> +				 __be32 data)
>>  {
>>  	PREP_ASYNC_HEAD_ADDRESS(TCODE_WRITEQ);
>>  	packet->header[3] = data;

Wrong, packet->header[] is currently CPU-endian.

(As a rule of thumb, if a sparse annotation patch adds new sparse
warnings, further investigation is called for.)

[...]
>> --- a/drivers/ieee1394/ieee1394_transactions.h
>> +++ b/drivers/ieee1394/ieee1394_transactions.h
[...]
>>  int hpsb_packet_success(struct hpsb_packet *packet);
>>  int hpsb_read(struct hpsb_host *host, nodeid_t node, unsigned int generation,
>> -	      u64 addr, quadlet_t *buffer, size_t length);
>> +	      u64 addr, __be32 *buffer, size_t length);
>>  int hpsb_write(struct hpsb_host *host, nodeid_t node, unsigned int generation,
>> -	       u64 addr, quadlet_t *buffer, size_t length);
>> +	       u64 addr, __be32 *buffer, size_t length);
>>  int hpsb_lock(struct hpsb_host *host, nodeid_t node, unsigned int generation,
>>  	      u64 addr, int extcode, quadlet_t *data, quadlet_t arg);

You generated the diff against code which contains the new firedtv DVB
driver but did not annotate the new ieee394 core code introduced for
firedtv and the ieee1394-interfacing firedtv code.  Doing the ieee1394
annotations in parallel with the ongoing work on the new firedtv driver
(instead of doing it sequentially) would be another unnecessary sink of
developer and maintainer time...
-- 
Stefan Richter
-=====-==--- =-== =-==-
http://arcgraph.de/sr/

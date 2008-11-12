Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbYKLSl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbYKLSl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbYKLSlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:41:50 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:41257 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYKLSlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:41:47 -0500
Message-ID: <491B2309.1090900@s5r6.in-berlin.de>
Date: Wed, 12 Nov 2008 19:40:09 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.17) Gecko/20080829 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [RFC-PATCH] ieee1394: endian annotations of drivers/ieee1394
References: <1226514321.16649.7.camel@brick>
In-Reply-To: <1226514321.16649.7.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Annotations are mostly trivial, quadlet_t -> __be32, octlet_t -> __be64
> which will have no effect on compiled code.


I haven't looked at it yet but have point out one important thing:
This is one of the many issues in drivers/ieee1394 which have already
been fixed by introducing drivers/firewire.  I appreciate the work which
you put into this, but I don't know yet if we want to take it in.

(adding Cc: linux1394-devel; quoting in full without further comments)

> 
> Changed the protoypes of the read_regs, write_regs, lock_regs, lock64_regs
> to take BE values rather than quadlet/octlet...propagated this through
> helper functions.
> 
> csr.c: work directly with the BE values in the lock functions and only
> convert to cpu-endian on demand, this part is non-trivial, but pretty
> easy to verify.  Introduce a few temporary variables to make in clear
> we are in cpu-endianness in a few cases.  Also, remove a few macros
> that were used only once and obscured what was actually happening when
> setting the type and generation...this eliminated some gratuitous
> byteswapping back and forth between cpu and big endian.
> 
> sbp.c: Eliminate the in-place be32-to-cpu inline which was only used once
> and do the conversion once in the places where each struct member is set/read,
> this propagates into one helper function that also now works directly in
> be32.
> 
> Also eliminate a few of the calls to the cpu-to-be32 that swapped a constant
> 8 bytes and set the struct members directly as be32 values.
> 
> dv1394.c is the only place where a change in behavior is intentional, the
> setting of the flags is done as cpu-endian where everwhere else it is done
> as little-endian, see the potion of the diff in ir_tasklet_func()
> 
> The rest of the changes end up being pretty simple annotations of struct
> members that were always treated as a particular endianness, mark them as
> such.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/ieee1394/csr.c                   |  148 ++++++++++++++++--------------
>  drivers/ieee1394/csr.h                   |   14 ++--
>  drivers/ieee1394/csr1212.c               |   55 +++++-------
>  drivers/ieee1394/csr1212.h               |   14 ++--
>  drivers/ieee1394/dv1394-private.h        |   44 +++++-----
>  drivers/ieee1394/dv1394.c                |   12 +-
>  drivers/ieee1394/eth1394.c               |   30 +++---
>  drivers/ieee1394/eth1394.h               |   12 +-
>  drivers/ieee1394/highlevel.c             |    8 +-
>  drivers/ieee1394/highlevel.h             |   20 ++--
>  drivers/ieee1394/hosts.c                 |    4 +-
>  drivers/ieee1394/hosts.h                 |    2 +-
>  drivers/ieee1394/ieee1394_core.h         |    2 +-
>  drivers/ieee1394/ieee1394_transactions.c |    8 +-
>  drivers/ieee1394/ieee1394_transactions.h |    6 +-
>  drivers/ieee1394/nodemgr.c               |   14 ++--
>  drivers/ieee1394/nodemgr.h               |    2 +-
>  drivers/ieee1394/ohci1394.c              |    2 +-
>  drivers/ieee1394/ohci1394.h              |    8 +-
>  drivers/ieee1394/pcilynx.h               |    2 +-
>  drivers/ieee1394/raw1394.c               |   42 ++++----
>  drivers/ieee1394/sbp2.c                  |  119 ++++++++++--------------
>  drivers/ieee1394/sbp2.h                  |   10 +-
>  drivers/ieee1394/video1394.c             |    2 +-
>  24 files changed, 278 insertions(+), 302 deletions(-)
> 
> diff --git a/drivers/ieee1394/csr.c b/drivers/ieee1394/csr.c
> index c90be40..b77eef1 100644
> --- a/drivers/ieee1394/csr.c
> +++ b/drivers/ieee1394/csr.c
> @@ -44,19 +44,19 @@ static struct csr1212_keyval *node_cap = NULL;
>  static void add_host(struct hpsb_host *host);
>  static void remove_host(struct hpsb_host *host);
>  static void host_reset(struct hpsb_host *host);
> -static int read_maps(struct hpsb_host *host, int nodeid, quadlet_t *buffer,
> +static int read_maps(struct hpsb_host *host, int nodeid, __be32 *buffer,
>  		     u64 addr, size_t length, u16 fl);
>  static int write_fcp(struct hpsb_host *host, int nodeid, int dest,
> -		     quadlet_t *data, u64 addr, size_t length, u16 flags);
> -static int read_regs(struct hpsb_host *host, int nodeid, quadlet_t *buf,
> +		     __be32 *data, u64 addr, size_t length, u16 flags);
> +static int read_regs(struct hpsb_host *host, int nodeid, __be32 *buf,
>  		     u64 addr, size_t length, u16 flags);
>  static int write_regs(struct hpsb_host *host, int nodeid, int destid,
> -		      quadlet_t *data, u64 addr, size_t length, u16 flags);
> -static int lock_regs(struct hpsb_host *host, int nodeid, quadlet_t *store,
> -		     u64 addr, quadlet_t data, quadlet_t arg, int extcode, u16 fl);
> -static int lock64_regs(struct hpsb_host *host, int nodeid, octlet_t * store,
> -		       u64 addr, octlet_t data, octlet_t arg, int extcode, u16 fl);
> -static int read_config_rom(struct hpsb_host *host, int nodeid, quadlet_t *buffer,
> +		      __be32 *data, u64 addr, size_t length, u16 flags);
> +static int lock_regs(struct hpsb_host *host, int nodeid, __be32 *store,
> +		     u64 addr, __be32 data, __be32 arg, int extcode, u16 fl);
> +static int lock64_regs(struct hpsb_host *host, int nodeid, __be64 *store,
> +		       u64 addr, __be64 data, __be64 arg, int extcode, u16 fl);
> +static int read_config_rom(struct hpsb_host *host, int nodeid, __be32 *buffer,
>  			   u64 addr, size_t length, u16 fl);
>  static u64 allocate_addr_range(u64 size, u32 alignment, void *__host);
>  static void release_addr_range(u64 addr, void *__host);
> @@ -93,7 +93,7 @@ struct csr1212_bus_ops csr_bus_ops = {
>  };
>  
>  
> -static u16 csr_crc16(unsigned *data, int length)
> +static u16 csr_crc16(__be32 *data, int length)
>  {
>          int check=0, i;
>          int shift, sum, next=0;
> @@ -167,7 +167,7 @@ static inline void calculate_expire(struct csr_control *csr)
>  static void add_host(struct hpsb_host *host)
>  {
>  	struct csr1212_keyval *root;
> -	quadlet_t bus_info[CSR_BUS_INFO_SIZE];
> +	__be32 bus_info[CSR_BUS_INFO_SIZE];
>  
>  	hpsb_register_addrspace(&csr_highlevel, host, &reg_ops,
>  				CSR_REGISTER_BASE,
> @@ -248,7 +248,7 @@ static void add_host(struct hpsb_host *host)
>  
>  static void remove_host(struct hpsb_host *host)
>  {
> -	quadlet_t bus_info[CSR_BUS_INFO_SIZE];
> +	__be32 bus_info[CSR_BUS_INFO_SIZE];
>  
>  	bus_info[1] = __constant_cpu_to_be32(0x31333934);
>  	bus_info[2] = cpu_to_be32((0 << CSR_IRMC_SHIFT) |
> @@ -306,7 +306,7 @@ int hpsb_update_config_rom(struct hpsb_host *host, const quadlet_t *new_rom,
>  
>  
>  /* Read topology / speed maps and configuration ROM */
> -static int read_maps(struct hpsb_host *host, int nodeid, quadlet_t *buffer,
> +static int read_maps(struct hpsb_host *host, int nodeid, __be32 *buffer,
>                       u64 addr, size_t length, u16 fl)
>  {
>  	unsigned long flags;
> @@ -330,7 +330,7 @@ static int read_maps(struct hpsb_host *host, int nodeid, quadlet_t *buffer,
>  
>  #define out if (--length == 0) break
>  
> -static int read_regs(struct hpsb_host *host, int nodeid, quadlet_t *buf,
> +static int read_regs(struct hpsb_host *host, int nodeid, __be32 *buf,
>                       u64 addr, size_t length, u16 flags)
>  {
>          int csraddr = addr - CSR_REGISTER_BASE;
> @@ -445,7 +445,7 @@ static int read_regs(struct hpsb_host *host, int nodeid, quadlet_t *buf,
>  }
>  
>  static int write_regs(struct hpsb_host *host, int nodeid, int destid,
> -		      quadlet_t *data, u64 addr, size_t length, u16 flags)
> +		      __be32 *data, u64 addr, size_t length, u16 flags)
>  {
>          int csraddr = addr - CSR_REGISTER_BASE;
>  
> @@ -532,8 +532,8 @@ static int write_regs(struct hpsb_host *host, int nodeid, int destid,
>  #undef out
>  
>  
> -static int lock_regs(struct hpsb_host *host, int nodeid, quadlet_t *store,
> -                     u64 addr, quadlet_t data, quadlet_t arg, int extcode, u16 fl)
> +static int lock_regs(struct hpsb_host *host, int nodeid, __be32 *store,
> +                     u64 addr, __be32 data, __be32 arg, int extcode, u16 fl)
>  {
>          int csraddr = addr - CSR_REGISTER_BASE;
>          unsigned long flags;
> @@ -546,11 +546,9 @@ static int lock_regs(struct hpsb_host *host, int nodeid, quadlet_t *store,
>              || extcode != EXTCODE_COMPARE_SWAP)
>                  goto unsupported_lockreq;
>  
> -        data = be32_to_cpu(data);
> -        arg = be32_to_cpu(arg);
> -
>  	/* Is somebody releasing the broadcast_channel on us? */
> -	if (csraddr == CSR_CHANNELS_AVAILABLE_HI && (data & 0x1)) {
> +	if (csraddr == CSR_CHANNELS_AVAILABLE_HI &&
> +	    (data & cpu_to_be32(0x1))) {
>  		/* Note: this is may not be the right way to handle
>  		 * the problem, so we should look into the proper way
>  		 * eventually. */
> @@ -558,7 +556,7 @@ static int lock_regs(struct hpsb_host *host, int nodeid, quadlet_t *store,
>  			  "broadcast channel 31.  Ignoring.",
>  			  NODE_BUS_ARGS(host, nodeid));
>  
> -		data &= ~0x1;	/* keep broadcast channel allocated */
> +		data &= ~cpu_to_be32(0x1);	/* keep broadcast channel allocated */
>  	}
>  
>          if (host->driver->hw_csr_reg) {
> @@ -566,7 +564,7 @@ static int lock_regs(struct hpsb_host *host, int nodeid, quadlet_t *store,
>  
>                  old = host->driver->
>                          hw_csr_reg(host, (csraddr - CSR_BUS_MANAGER_ID) >> 2,
> -                                   data, arg);
> +                                   be32_to_cpu(data), be32_to_cpu(arg));
>  
>                  *store = cpu_to_be32(old);
>                  return RCODE_COMPLETE;
> @@ -576,46 +574,55 @@ static int lock_regs(struct hpsb_host *host, int nodeid, quadlet_t *store,
>  
>          switch (csraddr) {
>          case CSR_BUS_MANAGER_ID:
> +	{
> +		__be32 regdata;
> +
>                  regptr = &host->csr.bus_manager_id;
> -		*store = cpu_to_be32(*regptr);
> -		if (*regptr == arg)
> -			*regptr = data;
> +		regdata = cpu_to_be32p(regptr);
> +		*store = regdata;
> +		if (regdata == arg)
> +			*regptr = be32_to_cpu(data);
>                  break;
> -
> +	}
>          case CSR_BANDWIDTH_AVAILABLE:
>          {
>                  quadlet_t bandwidth;
>                  quadlet_t old;
>                  quadlet_t new;
> +		__be32 regdata;
> +		u32 cpudata, cpuarg;
>  
>                  regptr = &host->csr.bandwidth_available;
>                  old = *regptr;
> +		regdata = cpu_to_be32p(regptr);
> +		cpudata = be32_to_cpu(data);
> +		cpuarg = be32_to_cpu(arg);
>  
>                  /* bandwidth available algorithm adapted from IEEE 1394a-2000 spec */
> -                if (arg > 0x1fff) {
> -                        *store = cpu_to_be32(old);	/* change nothing */
> +                if (cpuarg > 0x1fff) {
> +                        *store = regdata;	/* change nothing */
>  			break;
>                  }
> -                data &= 0x1fff;
> -                if (arg >= data) {
> +                cpudata &= 0x1fff;
> +                if (cpuarg >= cpudata) {
>                          /* allocate bandwidth */
> -                        bandwidth = arg - data;
> +                        bandwidth = cpuarg - cpudata;
>                          if (old >= bandwidth) {
>                                  new = old - bandwidth;
> -                                *store = cpu_to_be32(arg);
> +                                *store = arg;
>                                  *regptr = new;
>                          } else {
> -                                *store = cpu_to_be32(old);
> +                                *store = regdata;
>                          }
>                  } else {
>                          /* deallocate bandwidth */
> -                        bandwidth = data - arg;
> +                        bandwidth = cpudata - cpuarg;
>                          if (old + bandwidth < 0x2000) {
>                                  new = old + bandwidth;
> -                                *store = cpu_to_be32(arg);
> +                                *store = arg;
>                                  *regptr = new;
>                          } else {
> -                                *store = cpu_to_be32(old);
> +                                *store = regdata;
>                          }
>                  }
>                  break;
> @@ -624,15 +631,17 @@ static int lock_regs(struct hpsb_host *host, int nodeid, quadlet_t *store,
>          case CSR_CHANNELS_AVAILABLE_HI:
>          {
>                  /* Lock algorithm for CHANNELS_AVAILABLE as recommended by 1394a-2000 */
> -                quadlet_t affected_channels = arg ^ data;
> +                __be32 affected_channels = arg ^ data;
> +		__be32 regdata;
>  
>                  regptr = &host->csr.channels_available_hi;
> +		regdata = cpu_to_be32p(regptr);
>  
> -                if ((arg & affected_channels) == (*regptr & affected_channels)) {
> -                        *regptr ^= affected_channels;
> -                        *store = cpu_to_be32(arg);
> +                if ((arg & affected_channels) == (regdata & affected_channels)) {
> +                        *regptr ^= be32_to_cpu(affected_channels);
> +                        *store = arg;
>                  } else {
> -                        *store = cpu_to_be32(*regptr);
> +                        *store = regdata;
>                  }
>  
>                  break;
> @@ -641,15 +650,17 @@ static int lock_regs(struct hpsb_host *host, int nodeid, quadlet_t *store,
>          case CSR_CHANNELS_AVAILABLE_LO:
>          {
>                  /* Lock algorithm for CHANNELS_AVAILABLE as recommended by 1394a-2000 */
> -                quadlet_t affected_channels = arg ^ data;
> +                __be32 affected_channels = arg ^ data;
> +		__be32 regdata;
>  
>                  regptr = &host->csr.channels_available_lo;
> +		regdata = cpu_to_be32p(regptr);
>  
> -                if ((arg & affected_channels) == (*regptr & affected_channels)) {
> -                        *regptr ^= affected_channels;
> -                        *store = cpu_to_be32(arg);
> +                if ((arg & affected_channels) == (regdata & affected_channels)) {
> +                        *regptr ^= be32_to_cpu(affected_channels);
> +                        *store = arg;
>                  } else {
> -                        *store = cpu_to_be32(*regptr);
> +                        *store = regdata;
>                  }
>                  break;
>          }
> @@ -679,15 +690,12 @@ static int lock_regs(struct hpsb_host *host, int nodeid, quadlet_t *store,
>          }
>  }
>  
> -static int lock64_regs(struct hpsb_host *host, int nodeid, octlet_t * store,
> -		       u64 addr, octlet_t data, octlet_t arg, int extcode, u16 fl)
> +static int lock64_regs(struct hpsb_host *host, int nodeid, __be64 *store,
> +		       u64 addr, __be64 data, __be64 arg, int extcode, u16 fl)
>  {
>  	int csraddr = addr - CSR_REGISTER_BASE;
>  	unsigned long flags;
>  
> -	data = be64_to_cpu(data);
> -	arg = be64_to_cpu(arg);
> -
>  	if (csraddr & 0x3)
>  		return RCODE_TYPE_ERROR;
>  
> @@ -696,7 +704,8 @@ static int lock64_regs(struct hpsb_host *host, int nodeid, octlet_t * store,
>  		goto unsupported_lock64req;
>  
>  	/* Is somebody releasing the broadcast_channel on us? */
> -	if (csraddr == CSR_CHANNELS_AVAILABLE_HI && (data & 0x100000000ULL)) {
> +	if (csraddr == CSR_CHANNELS_AVAILABLE_HI &&
> +	    (data & cpu_to_be64(0x100000000ULL))) {
>  		/* Note: this is may not be the right way to handle
>  		 * the problem, so we should look into the proper way
>                   * eventually. */
> @@ -704,18 +713,18 @@ static int lock64_regs(struct hpsb_host *host, int nodeid, octlet_t * store,
>  			  "broadcast channel 31.  Ignoring.",
>  			  NODE_BUS_ARGS(host, nodeid));
>  
> -		data &= ~0x100000000ULL;	/* keep broadcast channel allocated */
> +		data &= ~cpu_to_be64(0x100000000ULL);	/* keep broadcast channel allocated */
>  	}
>  
>  	if (host->driver->hw_csr_reg) {
> -		quadlet_t data_hi, data_lo;
> -		quadlet_t arg_hi, arg_lo;
> +		u32 data_hi, data_lo;
> +		u32 arg_hi, arg_lo;
>  		quadlet_t old_hi, old_lo;
>  
> -		data_hi = data >> 32;
> -		data_lo = data & 0xFFFFFFFF;
> -		arg_hi = arg >> 32;
> -		arg_lo = arg & 0xFFFFFFFF;
> +		data_hi = be64_to_cpu(data) >> 32;
> +		data_lo = be64_to_cpu(data);
> +		arg_hi = be64_to_cpu(arg) >> 32;
> +		arg_lo = be64_to_cpu(arg);
>  
>  		old_hi = host->driver->hw_csr_reg(host, (csraddr - CSR_BUS_MANAGER_ID) >> 2,
>                                                    data_hi, arg_hi);
> @@ -725,19 +734,20 @@ static int lock64_regs(struct hpsb_host *host, int nodeid, octlet_t * store,
>  
>  		*store = cpu_to_be64(((octlet_t)old_hi << 32) | old_lo);
>  	} else {
> -		octlet_t old;
> -		octlet_t affected_channels = arg ^ data;
> +		__be64 old;
> +		__be64 affected_channels = arg ^ data;
>  
>  		spin_lock_irqsave(&host->csr.lock, flags);
>  
> -		old = ((octlet_t)host->csr.channels_available_hi << 32) | host->csr.channels_available_lo;
> +		old = cpu_to_be64(((octlet_t)host->csr.channels_available_hi << 32) |
> +				  host->csr.channels_available_lo);
>  
>  		if ((arg & affected_channels) == (old & affected_channels)) {
> -			host->csr.channels_available_hi ^= (affected_channels >> 32);
> -			host->csr.channels_available_lo ^= (affected_channels & 0xffffffff);
> -			*store = cpu_to_be64(arg);
> +			host->csr.channels_available_hi ^= be64_to_cpu(affected_channels) >> 32;
> +			host->csr.channels_available_lo ^= be64_to_cpu(affected_channels);
> +			*store = arg;
>  		} else {
> -			*store = cpu_to_be64(old);
> +			*store = old;
>  		}
>  
>  		spin_unlock_irqrestore(&host->csr.lock, flags);
> @@ -771,7 +781,7 @@ static int lock64_regs(struct hpsb_host *host, int nodeid, octlet_t * store,
>  }
>  
>  static int write_fcp(struct hpsb_host *host, int nodeid, int dest,
> -		     quadlet_t *data, u64 addr, size_t length, u16 flags)
> +		     __be32 *data, u64 addr, size_t length, u16 flags)
>  {
>          int csraddr = addr - CSR_REGISTER_BASE;
>  
> @@ -792,7 +802,7 @@ static int write_fcp(struct hpsb_host *host, int nodeid, int dest,
>          return RCODE_COMPLETE;
>  }
>  
> -static int read_config_rom(struct hpsb_host *host, int nodeid, quadlet_t *buffer,
> +static int read_config_rom(struct hpsb_host *host, int nodeid, __be32 *buffer,
>  			   u64 addr, size_t length, u16 fl)
>  {
>  	u32 offset = addr - CSR1212_REGISTER_SPACE_BASE;
> diff --git a/drivers/ieee1394/csr.h b/drivers/ieee1394/csr.h
> index f115465..87bd94f 100644
> --- a/drivers/ieee1394/csr.h
> +++ b/drivers/ieee1394/csr.h
> @@ -50,11 +50,11 @@
>  #define CSR_MAX_ROM_SHIFT		8
>  #define CSR_GENERATION_SHIFT		4
>  
> -#define CSR_SET_BUS_INFO_GENERATION(csr, gen)				\
> -	((csr)->bus_info_data[2] =					\
> -		cpu_to_be32((be32_to_cpu((csr)->bus_info_data[2]) &	\
> -			     ~(0xf << CSR_GENERATION_SHIFT)) |		\
> -			    (gen) << CSR_GENERATION_SHIFT))
> +static inline void csr_set_bus_info_generation(struct csr1212_csr *csr, u8 gen)
> +{
> +	csr->bus_info_data[2] &= ~cpu_to_be32(0xf << CSR_GENERATION_SHIFT);
> +	csr->bus_info_data[2] |= cpu_to_be32(gen << CSR_GENERATION_SHIFT);
> +}
>  
>  struct csr_control {
>  	spinlock_t lock;
> @@ -82,8 +82,8 @@ struct csr_control {
>  
>  	struct csr1212_csr *rom;
>  
> -	quadlet_t topology_map[256];
> -	quadlet_t speed_map[1024];
> +	__be32 topology_map[256];
> +	__be32 speed_map[1024];
>  };
>  
>  extern struct csr1212_bus_ops csr_bus_ops;
> diff --git a/drivers/ieee1394/csr1212.c b/drivers/ieee1394/csr1212.c
> index 5e38a68..907c2c1 100644
> --- a/drivers/ieee1394/csr1212.c
> +++ b/drivers/ieee1394/csr1212.c
> @@ -95,14 +95,14 @@ static void free_keyval(struct csr1212_keyval *kv)
>  	CSR1212_FREE(kv);
>  }
>  
> -static u16 csr1212_crc16(const u32 *buffer, size_t length)
> +static __be16 csr1212_crc16(const __be32 *buffer, size_t length)
>  {
>  	int shift;
>  	u32 data;
>  	u16 sum, crc = 0;
>  
>  	for (; length; length--) {
> -		data = be32_to_cpu(*buffer);
> +		data = be32_to_cpup(buffer);
>  		buffer++;
>  		for (shift = 28; shift >= 0; shift -= 4 ) {
>  			sum = ((crc >> 12) ^ (data >> shift)) & 0xf;
> @@ -115,14 +115,14 @@ static u16 csr1212_crc16(const u32 *buffer, size_t length)
>  }
>  
>  /* Microsoft computes the CRC with the bytes in reverse order. */
> -static u16 csr1212_msft_crc16(const u32 *buffer, size_t length)
> +static __be16 csr1212_msft_crc16(const __be32 *buffer, size_t length)
>  {
>  	int shift;
>  	u32 data;
>  	u16 sum, crc = 0;
>  
>  	for (; length; length--) {
> -		data = le32_to_cpu(*buffer);
> +		data = le32_to_cpup((__force __le32 *)buffer);
>  		buffer++;
>  		for (shift = 28; shift >= 0; shift -= 4 ) {
>  			sum = ((crc >> 12) ^ (data >> shift)) & 0xf;
> @@ -198,7 +198,7 @@ struct csr1212_csr *csr1212_create_csr(struct csr1212_bus_ops *ops,
>  }
>  
>  void csr1212_init_local_csr(struct csr1212_csr *csr,
> -			    const u32 *bus_info_data, int max_rom)
> +			    const __be32 *bus_info_data, int max_rom)
>  {
>  	static const int mr_map[] = { 4, 64, 1024, 0 };
>  
> @@ -363,19 +363,6 @@ int csr1212_attach_keyval_to_directory(struct csr1212_keyval *dir,
>  	return __csr1212_attach_keyval_to_directory(dir, kv, true);
>  }
>  
> -#define CSR1212_DESCRIPTOR_LEAF_DATA(kv) \
> -	(&((kv)->value.leaf.data[1]))
> -
> -#define CSR1212_DESCRIPTOR_LEAF_SET_TYPE(kv, type) \
> -	((kv)->value.leaf.data[0] = \
> -	 cpu_to_be32(CSR1212_DESCRIPTOR_LEAF_SPECIFIER_ID(kv) | \
> -		     ((type) << CSR1212_DESCRIPTOR_LEAF_TYPE_SHIFT)))
> -#define CSR1212_DESCRIPTOR_LEAF_SET_SPECIFIER_ID(kv, spec_id) \
> -	((kv)->value.leaf.data[0] = \
> -	 cpu_to_be32((CSR1212_DESCRIPTOR_LEAF_TYPE(kv) << \
> -		      CSR1212_DESCRIPTOR_LEAF_TYPE_SHIFT) | \
> -		     ((spec_id) & CSR1212_DESCRIPTOR_LEAF_SPECIFIER_ID_MASK)))
> -
>  static struct csr1212_keyval *
>  csr1212_new_descriptor_leaf(u8 dtype, u32 specifier_id,
>  			    const void *data, size_t data_len)
> @@ -387,11 +374,12 @@ csr1212_new_descriptor_leaf(u8 dtype, u32 specifier_id,
>  	if (!kv)
>  		return NULL;
>  
> -	CSR1212_DESCRIPTOR_LEAF_SET_TYPE(kv, dtype);
> -	CSR1212_DESCRIPTOR_LEAF_SET_SPECIFIER_ID(kv, specifier_id);
> +	kv->value.leaf.data[0] = cpu_to_be32(
> +				 (dtype << CSR1212_DESCRIPTOR_LEAF_TYPE_SHIFT) |
> +				 (specifier_id & CSR1212_DESCRIPTOR_LEAF_SPECIFIER_ID_MASK));
>  
>  	if (data)
> -		memcpy(CSR1212_DESCRIPTOR_LEAF_DATA(kv), data, data_len);
> +		memcpy(&kv->value.leaf.data[1], data, data_len);
>  
>  	return kv;
>  }
> @@ -435,7 +423,7 @@ static int csr1212_check_minimal_ascii(const char *s)
>  struct csr1212_keyval *csr1212_new_string_descriptor_leaf(const char *s)
>  {
>  	struct csr1212_keyval *kv;
> -	u32 *text;
> +	__be32 *text;
>  	size_t str_len, quads;
>  
>  	if (!s || !*s || csr1212_check_minimal_ascii(s))
> @@ -450,7 +438,7 @@ struct csr1212_keyval *csr1212_new_string_descriptor_leaf(const char *s)
>  
>  	kv->value.leaf.data[1] = 0;	/* width, character_set, language */
>  	text = CSR1212_TEXTUAL_DESCRIPTOR_LEAF_DATA(kv);
> -	text[quads - 1] = 0;		/* padding */
> +	text[quads - 1] = cpu_to_be32(0);		/* padding */
>  	memcpy(text, s, str_len);
>  
>  	return kv;
> @@ -793,7 +781,7 @@ csr1212_generate_positions(struct csr1212_csr_rom_cache *cache,
>  #define CSR1212_KV_KEY_TYPE_MASK	0x3	/* after shift */
>  
>  static void
> -csr1212_generate_tree_subdir(struct csr1212_keyval *dir, u32 *data_buffer)
> +csr1212_generate_tree_subdir(struct csr1212_keyval *dir, __be32 *data_buffer)
>  {
>  	struct csr1212_dentry *dentry;
>  	struct csr1212_keyval *last_extkey_spec = NULL;
> @@ -865,11 +853,11 @@ csr1212_generate_tree_subdir(struct csr1212_keyval *dir, u32 *data_buffer)
>  }
>  
>  struct csr1212_keyval_img {
> -	u16 length;
> -	u16 crc;
> +	__be16 length;
> +	__be16 crc;
>  
>  	/* Must be last */
> -	u32 data[0];	/* older gcc can't handle [] which is standard */
> +	__be32 data[0];	/* older gcc can't handle [] which is standard */
>  };
>  
>  static void csr1212_fill_cache(struct csr1212_csr_rom_cache *cache)
> @@ -1054,7 +1042,7 @@ int csr1212_read(struct csr1212_csr *csr, u32 offset, void *buffer, u32 len)
>   * algorithm.  We don't fail, we just warn... approximately once per GUID.
>   */
>  static void
> -csr1212_check_crc(const u32 *buffer, size_t length, u16 crc, __be32 *guid)
> +csr1212_check_crc(const __be32 *buffer, size_t length, __be16 crc, __be32 *guid)
>  {
>  	static u64 last_bad_eui64;
>  	u64 eui64 = ((u64)be32_to_cpu(guid[0]) << 32) | be32_to_cpu(guid[1]);
> @@ -1135,7 +1123,7 @@ static int csr1212_parse_bus_info_block(struct csr1212_csr *csr)
>  #define CSR1212_KV_VAL(q)	(be32_to_cpu(q) & CSR1212_KV_VAL_MASK)
>  
>  static int
> -csr1212_parse_dir_entry(struct csr1212_keyval *dir, u32 ki, u32 kv_pos)
> +csr1212_parse_dir_entry(struct csr1212_keyval *dir, __be32 ki, u32 kv_pos)
>  {
>  	int ret = CSR1212_SUCCESS;
>  	struct csr1212_keyval *k = NULL;
> @@ -1226,12 +1214,12 @@ int csr1212_parse_keyval(struct csr1212_keyval *kv,
>  	switch (kv->key.type) {
>  	case CSR1212_KV_TYPE_DIRECTORY:
>  		for (i = 0; i < kvi_len; i++) {
> -			u32 ki = kvi->data[i];
> +			__be32 ki = kvi->data[i];
>  
>  			/* Some devices put null entries in their unit
>  			 * directories.  If we come across such an entry,
>  			 * then skip it. */
> -			if (ki == 0x0)
> +			if (ki == cpu_to_be32(0x0))
>  				continue;
>  			ret = csr1212_parse_dir_entry(kv, ki,
>  					kv->offset + quads_to_bytes(i + 1));
> @@ -1268,7 +1256,7 @@ csr1212_read_keyval(struct csr1212_csr *csr, struct csr1212_keyval *kv)
>  	struct csr1212_csr_rom_cache *cache;
>  	int cache_index;
>  	u64 addr;
> -	u32 *cache_ptr;
> +	__be32 *cache_ptr;
>  	u16 kv_len = 0;
>  
>  	BUG_ON(!csr || !kv || csr->max_rom < 1);
> @@ -1281,7 +1269,8 @@ csr1212_read_keyval(struct csr1212_csr *csr, struct csr1212_keyval *kv)
>  			break;
>  
>  	if (!cache) {
> -		u32 q, cache_size;
> +		u32 cache_size;
> +		__be32 q;
>  
>  		/* Only create a new cache for Extended ROM leaves. */
>  		if (kv->key.id != CSR1212_KV_ID_EXTENDED_ROM)
> diff --git a/drivers/ieee1394/csr1212.h b/drivers/ieee1394/csr1212.h
> index 043039f..51452eb 100644
> --- a/drivers/ieee1394/csr1212.h
> +++ b/drivers/ieee1394/csr1212.h
> @@ -117,15 +117,15 @@
>  struct csr1212_bus_info_block_img {
>  	u8 length;
>  	u8 crc_length;
> -	u16 crc;
> +	__be16 crc;
>  
>  	/* Must be last */
> -	u32 data[0];	/* older gcc can't handle [] which is standard */
> +	__be32 data[0];	/* older gcc can't handle [] which is standard */
>  };
>  
>  struct csr1212_leaf {
>  	int len;
> -	u32 *data;
> +	__be32 *data;
>  };
>  
>  struct csr1212_dentry {
> @@ -175,13 +175,13 @@ struct csr1212_csr_rom_cache {
>  	size_t len;
>  
>  	/* Must be last */
> -	u32 data[0];	/* older gcc can't handle [] which is standard */
> +	__be32 data[0];	/* older gcc can't handle [] which is standard */
>  };
>  
>  struct csr1212_csr {
>  	size_t bus_info_len;	/* bus info block length in bytes */
>  	size_t crc_len;		/* crc length in bytes */
> -	u32 *bus_info_data;	/* bus info data incl bus name and EUI */
> +	__be32 *bus_info_data;	/* bus info data incl bus name and EUI */
>  
>  	void *private;		/* private, bus specific data */
>  	struct csr1212_bus_ops *ops;
> @@ -215,7 +215,7 @@ struct csr1212_bus_ops {
>  	/* This function is used by csr1212 to determine the max read request
>  	 * supported by a remote node when reading the ConfigROM space.  Must
>  	 * return 0, 1, or 2 per IEEE 1212.  */
> -	int (*get_max_rom) (u32 *bus_info, void *private);
> +	int (*get_max_rom) (__be32 *bus_info, void *private);
>  };
>  
>  
> @@ -262,7 +262,7 @@ extern struct csr1212_csr *csr1212_create_csr(struct csr1212_bus_ops *ops,
>  					      size_t bus_info_size,
>  					      void *private);
>  extern void csr1212_init_local_csr(struct csr1212_csr *csr,
> -				   const u32 *bus_info_data, int max_rom);
> +				   const __be32 *bus_info_data, int max_rom);
>  
>  
>  /* Destroy a Configuration ROM tree and release all memory taken by the tree. */
> diff --git a/drivers/ieee1394/dv1394-private.h b/drivers/ieee1394/dv1394-private.h
> index 7d1d284..18b92cb 100644
> --- a/drivers/ieee1394/dv1394-private.h
> +++ b/drivers/ieee1394/dv1394-private.h
> @@ -77,11 +77,11 @@ static inline void fill_cip_header(struct CIP_header *cip,
>     See the Texas Instruments OHCI 1394 chipset documentation.
>  */
>  
> -struct output_more_immediate { u32 q[8]; };
> -struct output_more { u32 q[4]; };
> -struct output_last { u32 q[4]; };
> -struct input_more { u32 q[4]; };
> -struct input_last { u32 q[4]; };
> +struct output_more_immediate { __le32 q[8]; };
> +struct output_more { __le32 q[4]; };
> +struct output_last { __le32 q[4]; };
> +struct input_more { __le32 q[4]; };
> +struct input_last { __le32 q[4]; };
>  
>  /* outputs */
>  
> @@ -92,9 +92,9 @@ static inline void fill_output_more_immediate(struct output_more_immediate *omi,
>  					      unsigned int  payload_size)
>  {
>  	omi->q[0] = cpu_to_le32(0x02000000 | 8); /* OUTPUT_MORE_IMMEDIATE; 8 is the size of the IT header */
> -	omi->q[1] = 0;
> -	omi->q[2] = 0;
> -	omi->q[3] = 0;
> +	omi->q[1] = cpu_to_le32(0);
> +	omi->q[2] = cpu_to_le32(0);
> +	omi->q[3] = cpu_to_le32(0);
>  
>  	/* IT packet header */
>  	omi->q[4] = cpu_to_le32(  (0x0 << 16)  /* IEEE1394_SPEED_100 */
> @@ -106,8 +106,8 @@ static inline void fill_output_more_immediate(struct output_more_immediate *omi,
>  	/* reserved field; mimic behavior of my Sony DSR-40 */
>  	omi->q[5] = cpu_to_le32((payload_size << 16) | (0x7F << 8) | 0xA0);
>  
> -	omi->q[6] = 0;
> -	omi->q[7] = 0;
> +	omi->q[6] = cpu_to_le32(0);
> +	omi->q[7] = cpu_to_le32(0);
>  }
>  
>  static inline void fill_output_more(struct output_more *om,
> @@ -116,8 +116,8 @@ static inline void fill_output_more(struct output_more *om,
>  {
>  	om->q[0] = cpu_to_le32(data_size);
>  	om->q[1] = cpu_to_le32(data_phys_addr);
> -	om->q[2] = 0;
> -	om->q[3] = 0;
> +	om->q[2] = cpu_to_le32(0);
> +	om->q[3] = cpu_to_le32(0);
>  }
>  
>  static inline void fill_output_last(struct output_last *ol,
> @@ -140,8 +140,8 @@ static inline void fill_output_last(struct output_last *ol,
>  
>  	ol->q[0] = cpu_to_le32(temp);
>  	ol->q[1] = cpu_to_le32(data_phys_addr);
> -	ol->q[2] = 0;
> -	ol->q[3] = 0;
> +	ol->q[2] = cpu_to_le32(0);
> +	ol->q[3] = cpu_to_le32(0);
>  }
>  
>  /* inputs */
> @@ -161,8 +161,8 @@ static inline void fill_input_more(struct input_more *im,
>  
>  	im->q[0] = cpu_to_le32(temp);
>  	im->q[1] = cpu_to_le32(data_phys_addr);
> -	im->q[2] = 0; /* branchAddress and Z not use in packet-per-buffer mode */
> -	im->q[3] = 0; /* xferStatus & resCount, resCount must be initialize to data_size */
> +	im->q[2] = cpu_to_le32(0); /* branchAddress and Z not use in packet-per-buffer mode */
> +	im->q[3] = cpu_to_le32(0); /* xferStatus & resCount, resCount must be initialize to data_size */
>  }
>   
>  static inline void fill_input_last(struct input_last *il,
> @@ -331,7 +331,7 @@ struct frame {
>  
>  	/* points to status/timestamp field of first DMA packet */
>  	/* (we'll check it later to monitor timestamp accuracy) */
> -	u32 *frame_begin_timestamp;
> +	__le32 *frame_begin_timestamp;
>  
>  	/* the timestamp we assigned to the first packet in the frame */
>  	u32 assigned_timestamp;
> @@ -348,15 +348,15 @@ struct frame {
>  	   that can cause interrupts. We'll check these from the
>  	   interrupt handler.
>  	*/
> -	u32 *mid_frame_timestamp;
> -	u32 *frame_end_timestamp;
> +	__le32 *mid_frame_timestamp;
> +	__le32 *frame_end_timestamp;
>  
>  	/* branch address field of final packet. This is effectively
>  	   the "tail" in the chain of DMA descriptor blocks.
>  	   We will fill it with the address of the first DMA descriptor
>  	   block in the subsequent frame, once it is ready.
>  	*/
> -	u32 *frame_end_branch;
> +	__le32 *frame_end_branch;
>  
>  	/* the number of descriptors in the first descriptor block
>  	   of the frame. Needed to start DMA */
> @@ -365,10 +365,10 @@ struct frame {
>  
>  
>  struct packet {
> -	u16	timestamp;
> +	__le16	timestamp;
>  	u16	invalid;
>  	u16	iso_header;
> -	u16	data_length;
> +	__le16	data_length;
>  	u32	cip_h1;
>  	u32	cip_h2;
>  	unsigned char data[480];
> diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
> index c19f232..a329e6b 100644
> --- a/drivers/ieee1394/dv1394.c
> +++ b/drivers/ieee1394/dv1394.c
> @@ -265,7 +265,7 @@ static void frame_prepare(struct video_card *video, unsigned int this_frame)
>  	/* these flags denote packets that need special attention */
>  	int empty_packet, first_packet, last_packet, mid_packet;
>  
> -	u32 *branch_address, *last_branch_address = NULL;
> +	__le32 *branch_address, *last_branch_address = NULL;
>  	unsigned long data_p;
>  	int first_packet_empty = 0;
>  	u32 cycleTimer, ct_sec, ct_cyc, ct_off;
> @@ -848,7 +848,7 @@ static void receive_packets(struct video_card *video)
>  	dma_addr_t block_dma = 0;
>  	struct packet *data = NULL;
>  	dma_addr_t data_dma = 0;
> -	u32 *last_branch_address = NULL;
> +	__le32 *last_branch_address = NULL;
>  	unsigned long irq_flags;
>  	int want_interrupt = 0;
>  	struct frame *f = NULL;
> @@ -2110,17 +2110,17 @@ static void ir_tasklet_func(unsigned long data)
>  			f = video->frames[next_i / MAX_PACKETS];
>  			next = &(f->descriptor_pool[next_i % MAX_PACKETS]);
>  			next_dma = ((unsigned long) block - (unsigned long) f->descriptor_pool) + f->descriptor_pool_dma;
> -			next->u.in.il.q[0] |= 3 << 20; /* enable interrupt */
> -			next->u.in.il.q[2] = 0; /* disable branch */
> +			next->u.in.il.q[0] |= cpu_to_le32(3 << 20); /* enable interrupt */
> +			next->u.in.il.q[2] = cpu_to_le32(0); /* disable branch */
>  
>  			/* link previous to next */
>  			prev_i = (next_i == 0) ? (MAX_PACKETS * video->n_frames - 1) : (next_i - 1);
>  			f = video->frames[prev_i / MAX_PACKETS];
>  			prev = &(f->descriptor_pool[prev_i % MAX_PACKETS]);
>  			if (prev_i % (MAX_PACKETS/2)) {
> -				prev->u.in.il.q[0] &= ~(3 << 20); /* no interrupt */
> +				prev->u.in.il.q[0] &= ~cpu_to_le32(3 << 20); /* no interrupt */
>  			} else {
> -				prev->u.in.il.q[0] |= 3 << 20; /* enable interrupt */
> +				prev->u.in.il.q[0] |= cpu_to_le32(3 << 20); /* enable interrupt */
>  			}
>  			prev->u.in.il.q[2] = cpu_to_le32(next_dma | 1); /* set Z=1 */
>  			wmb();
> diff --git a/drivers/ieee1394/eth1394.c b/drivers/ieee1394/eth1394.c
> index 2012869..0164886 100644
> --- a/drivers/ieee1394/eth1394.c
> +++ b/drivers/ieee1394/eth1394.c
> @@ -175,7 +175,7 @@ static void ether1394_iso(struct hpsb_iso *iso);
>  static struct ethtool_ops ethtool_ops;
>  
>  static int ether1394_write(struct hpsb_host *host, int srcid, int destid,
> -			   quadlet_t *data, u64 addr, size_t len, u16 flags);
> +			   __be32 *data, u64 addr, size_t len, u16 flags);
>  static void ether1394_add_host(struct hpsb_host *host);
>  static void ether1394_remove_host(struct hpsb_host *host);
>  static void ether1394_host_reset(struct hpsb_host *host);
> @@ -767,7 +767,7 @@ static int ether1394_header_parse(const struct sk_buff *skb,
>  static int ether1394_header_cache(const struct neighbour *neigh,
>  				  struct hh_cache *hh)
>  {
> -	unsigned short type = hh->hh_type;
> +	__be16 type = hh->hh_type;
>  	struct net_device *dev = neigh->dev;
>  	struct eth1394hdr *eth =
>  		(struct eth1394hdr *)((u8 *)hh->hh_data + 16 - ETH1394_HLEN);
> @@ -795,7 +795,7 @@ static void ether1394_header_cache_update(struct hh_cache *hh,
>   ******************************************/
>  
>  /* Copied from net/ethernet/eth.c */
> -static u16 ether1394_type_trans(struct sk_buff *skb, struct net_device *dev)
> +static __be16 ether1394_type_trans(struct sk_buff *skb, struct net_device *dev)
>  {
>  	struct eth1394hdr *eth;
>  	unsigned char *rawp;
> @@ -829,17 +829,17 @@ static u16 ether1394_type_trans(struct sk_buff *skb, struct net_device *dev)
>  
>  /* Parse an encapsulated IP1394 header into an ethernet frame packet.
>   * We also perform ARP translation here, if need be.  */
> -static u16 ether1394_parse_encap(struct sk_buff *skb, struct net_device *dev,
> +static __be16 ether1394_parse_encap(struct sk_buff *skb, struct net_device *dev,
>  				 nodeid_t srcid, nodeid_t destid,
> -				 u16 ether_type)
> +				 __be16 ether_type)
>  {
>  	struct eth1394_priv *priv = netdev_priv(dev);
> -	u64 dest_hw;
> -	unsigned short ret = 0;
> +	__be64 dest_hw;
> +	__be16 ret = cpu_to_be16(0);
>  
>  	/* Setup our hw addresses. We use these to build the ethernet header. */
>  	if (destid == (LOCAL_BUS | ALL_NODES))
> -		dest_hw = ~0ULL;  /* broadcast */
> +		dest_hw = ~cpu_to_be64(0ULL);  /* broadcast */
>  	else
>  		dest_hw = cpu_to_be64((u64)priv->host->csr.guid_hi << 32 |
>  				      priv->host->csr.guid_lo);
> @@ -873,7 +873,7 @@ static u16 ether1394_parse_encap(struct sk_buff *skb, struct net_device *dev,
>  		node = eth1394_find_node_guid(&priv->ip_node_list,
>  					      be64_to_cpu(guid));
>  		if (!node)
> -			return 0;
> +			return cpu_to_be16(0);
>  
>  		node_info =
>  		    (struct eth1394_node_info *)node->ud->device.driver_data;
> @@ -1063,7 +1063,7 @@ static int ether1394_data_handler(struct net_device *dev, int srcid, int destid,
>  	unsigned long flags;
>  	struct eth1394_priv *priv = netdev_priv(dev);
>  	union eth1394_hdr *hdr = (union eth1394_hdr *)buf;
> -	u16 ether_type = 0;  /* initialized to clear warning */
> +	__be16 ether_type = cpu_to_be16(0);  /* initialized to clear warning */
>  	int hdr_len;
>  	struct unit_directory *ud = priv->ud_list[NODEID_TO_NODE(srcid)];
>  	struct eth1394_node_info *node_info;
> @@ -1240,7 +1240,7 @@ bad_proto:
>  }
>  
>  static int ether1394_write(struct hpsb_host *host, int srcid, int destid,
> -			   quadlet_t *data, u64 addr, size_t len, u16 flags)
> +			   __be32 *data, u64 addr, size_t len, u16 flags)
>  {
>  	struct eth1394_host_info *hi;
>  
> @@ -1259,7 +1259,7 @@ static int ether1394_write(struct hpsb_host *host, int srcid, int destid,
>  
>  static void ether1394_iso(struct hpsb_iso *iso)
>  {
> -	quadlet_t *data;
> +	__be32 *data;
>  	char *buf;
>  	struct eth1394_host_info *hi;
>  	struct net_device *dev;
> @@ -1283,7 +1283,7 @@ static void ether1394_iso(struct hpsb_iso *iso)
>  	for (i = 0; i < nready; i++) {
>  		struct hpsb_iso_packet_info *info =
>  			&iso->infos[(iso->first_packet + i) % iso->buf_packets];
> -		data = (quadlet_t *)(iso->data_buf.kvirt + info->offset);
> +		data = (__be32 *)(iso->data_buf.kvirt + info->offset);
>  
>  		/* skip over GASP header */
>  		buf = (char *)data + 8;
> @@ -1451,7 +1451,7 @@ static void ether1394_prep_gasp_packet(struct hpsb_packet *p,
>  	p->header[0] = length << 16 | 3 << 14 | priv->broadcast_channel << 8 |
>  		       TCODE_STREAM_DATA << 4;
>  	p->data_size = length;
> -	p->data = (quadlet_t *)skb->data - 2;
> +	p->data = (__be32 *)skb->data - 2;
>  	p->data[0] = cpu_to_be32(priv->host->node_id << 16 |
>  				 ETHER1394_GASP_SPECIFIER_ID_HI);
>  	p->data[1] = cpu_to_be32(ETHER1394_GASP_SPECIFIER_ID_LO << 24 |
> @@ -1614,7 +1614,7 @@ static int ether1394_tx(struct sk_buff *skb, struct net_device *dev)
>  		if (max_payload < dg_size + hdr_type_len[ETH1394_HDR_LF_UF])
>  			priv->bc_dgl++;
>  	} else {
> -		__be64 guid = get_unaligned((u64 *)hdr_buf.h_dest);
> +		__be64 guid = get_unaligned((__be64 *)hdr_buf.h_dest);
>  
>  		node = eth1394_find_node_guid(&priv->ip_node_list,
>  					      be64_to_cpu(guid));
> diff --git a/drivers/ieee1394/eth1394.h b/drivers/ieee1394/eth1394.h
> index 4f3e2dd..5de6cf7 100644
> --- a/drivers/ieee1394/eth1394.h
> +++ b/drivers/ieee1394/eth1394.h
> @@ -82,7 +82,7 @@ struct eth1394_priv {
>  
>  struct eth1394hdr {
>  	unsigned char	h_dest[ETH1394_ALEN];	/* destination eth1394 addr	*/
> -	unsigned short	h_proto;		/* packet type ID field	*/
> +	__be16		h_proto;		/* packet type ID field	*/
>  }  __attribute__((packed));
>  
>  static inline struct eth1394hdr *eth1394_hdr(const struct sk_buff *skb)
> @@ -117,7 +117,7 @@ struct eth1394_ff_hdr {
>  	u16 lf:2;
>  	u16 res1:2;
>  	u16 dg_size:12;		/* Datagram size */
> -	u16 ether_type;		/* Ethernet packet type */
> +	__be16 ether_type;		/* Ethernet packet type */
>  	u16 dgl;		/* Datagram label */
>  	u16 res2;
>  } __attribute__((packed));
> @@ -126,7 +126,7 @@ struct eth1394_ff_hdr {
>  	u16 dg_size:12;
>  	u16 res1:2;
>  	u16 lf:2;
> -	u16 ether_type;
> +	__be16 ether_type;
>  	u16 dgl;
>  	u16 res2;
>  } __attribute__((packed));
> @@ -207,11 +207,11 @@ struct eth1394_arp {
>  	u16 opcode;		/* ARP Opcode	*/
>  	/* Above is exactly the same format as struct arphdr */
>  
> -	u64 s_uniq_id;		/* Sender's 64bit EUI			*/
> +	__be64 s_uniq_id;		/* Sender's 64bit EUI			*/
>  	u8 max_rec;		/* Sender's max packet size		*/
>  	u8 sspd;		/* Sender's max speed			*/
> -	u16 fifo_hi;		/* hi 16bits of sender's FIFO addr	*/
> -	u32 fifo_lo;		/* lo 32bits of sender's FIFO addr	*/
> +	__be16 fifo_hi;		/* hi 16bits of sender's FIFO addr	*/
> +	__be32 fifo_lo;		/* lo 32bits of sender's FIFO addr	*/
>  	u32 sip;		/* Sender's IP Address			*/
>  	u32 tip;		/* IP Address of requested hw addr	*/
>  };
> diff --git a/drivers/ieee1394/highlevel.c b/drivers/ieee1394/highlevel.c
> index 918ffc4..7a645f4 100644
> --- a/drivers/ieee1394/highlevel.c
> +++ b/drivers/ieee1394/highlevel.c
> @@ -637,8 +637,8 @@ int highlevel_write(struct hpsb_host *host, int nodeid, int destid, void *data,
>  	return rcode;
>  }
>  
> -int highlevel_lock(struct hpsb_host *host, int nodeid, quadlet_t *store,
> -		   u64 addr, quadlet_t data, quadlet_t arg, int ext_tcode,
> +int highlevel_lock(struct hpsb_host *host, int nodeid, __be32 *store,
> +		   u64 addr, __be32 data, __be32 arg, int ext_tcode,
>  		   u16 flags)
>  {
>  	struct hpsb_address_serve *as;
> @@ -663,8 +663,8 @@ int highlevel_lock(struct hpsb_host *host, int nodeid, quadlet_t *store,
>  	return rcode;
>  }
>  
> -int highlevel_lock64(struct hpsb_host *host, int nodeid, octlet_t *store,
> -		     u64 addr, octlet_t data, octlet_t arg, int ext_tcode,
> +int highlevel_lock64(struct hpsb_host *host, int nodeid, __be64 *store,
> +		     u64 addr, __be64 data, __be64 arg, int ext_tcode,
>  		     u16 flags)
>  {
>  	struct hpsb_address_serve *as;
> diff --git a/drivers/ieee1394/highlevel.h b/drivers/ieee1394/highlevel.h
> index bc5d085..27554d2 100644
> --- a/drivers/ieee1394/highlevel.h
> +++ b/drivers/ieee1394/highlevel.h
> @@ -72,18 +72,18 @@ struct hpsb_address_ops {
>  	 * In the first case a response will be generated.  In the latter case,
>  	 * no response will be sent and the driver which handled the request
>  	 * will send the response itself. */
> -	int (*read)(struct hpsb_host *host, int nodeid, quadlet_t *buffer,
> +	int (*read)(struct hpsb_host *host, int nodeid, __be32 *buffer,
>  		    u64 addr, size_t length, u16 flags);
>  	int (*write)(struct hpsb_host *host, int nodeid, int destid,
> -		     quadlet_t *data, u64 addr, size_t length, u16 flags);
> +		     __be32 *data, u64 addr, size_t length, u16 flags);
>  
>  	/* Lock transactions: write results of ext_tcode operation into
>  	 * *store. */
> -	int (*lock)(struct hpsb_host *host, int nodeid, quadlet_t *store,
> -		    u64 addr, quadlet_t data, quadlet_t arg, int ext_tcode,
> +	int (*lock)(struct hpsb_host *host, int nodeid, __be32 *store,
> +		    u64 addr, __be32 data, __be32 arg, int ext_tcode,
>  		    u16 flags);
> -	int (*lock64)(struct hpsb_host *host, int nodeid, octlet_t *store,
> -		      u64 addr, octlet_t data, octlet_t arg, int ext_tcode,
> +	int (*lock64)(struct hpsb_host *host, int nodeid, __be64 *store,
> +		      u64 addr, __be64 data, __be64 arg, int ext_tcode,
>  		      u16 flags);
>  };
>  
> @@ -94,11 +94,11 @@ int highlevel_read(struct hpsb_host *host, int nodeid, void *data, u64 addr,
>  		   unsigned int length, u16 flags);
>  int highlevel_write(struct hpsb_host *host, int nodeid, int destid, void *data,
>  		    u64 addr, unsigned int length, u16 flags);
> -int highlevel_lock(struct hpsb_host *host, int nodeid, quadlet_t *store,
> -		   u64 addr, quadlet_t data, quadlet_t arg, int ext_tcode,
> +int highlevel_lock(struct hpsb_host *host, int nodeid, __be32 *store,
> +		   u64 addr, __be32 data, __be32 arg, int ext_tcode,
>  		   u16 flags);
> -int highlevel_lock64(struct hpsb_host *host, int nodeid, octlet_t *store,
> -		     u64 addr, octlet_t data, octlet_t arg, int ext_tcode,
> +int highlevel_lock64(struct hpsb_host *host, int nodeid, __be64 *store,
> +		     u64 addr, __be64 data, __be64 arg, int ext_tcode,
>  		     u16 flags);
>  void highlevel_fcp_request(struct hpsb_host *host, int nodeid, int direction,
>  			   void *data, size_t length);
> diff --git a/drivers/ieee1394/hosts.c b/drivers/ieee1394/hosts.c
> index 237d0c9..5fcddd5 100644
> --- a/drivers/ieee1394/hosts.c
> +++ b/drivers/ieee1394/hosts.c
> @@ -41,11 +41,11 @@ static void delayed_reset_bus(struct work_struct *work)
>  	if (generation > 0xf || generation < 2)
>  		generation = 2;
>  
> -	CSR_SET_BUS_INFO_GENERATION(host->csr.rom, generation);
> +	csr_set_bus_info_generation(host->csr.rom, generation);
>  	if (csr1212_generate_csr_image(host->csr.rom) != CSR1212_SUCCESS) {
>  		/* CSR image creation failed.
>  		 * Reset generation field and do not issue a bus reset. */
> -		CSR_SET_BUS_INFO_GENERATION(host->csr.rom,
> +		csr_set_bus_info_generation(host->csr.rom,
>  					    host->csr.generation);
>  		return;
>  	}
> diff --git a/drivers/ieee1394/hosts.h b/drivers/ieee1394/hosts.h
> index e4e8aeb..91aea05 100644
> --- a/drivers/ieee1394/hosts.h
> +++ b/drivers/ieee1394/hosts.h
> @@ -150,7 +150,7 @@ struct hpsb_host_driver {
>  	 * to set the hardware ConfigROM if the hardware supports handling
>  	 * reads to the ConfigROM on its own. */
>  	void (*set_hw_config_rom)(struct hpsb_host *host,
> -				  quadlet_t *config_rom);
> +				  __be32 *config_rom);
>  
>  	/* This function shall implement packet transmission based on
>  	 * packet->type.  It shall CRC both parts of the packet (unless
> diff --git a/drivers/ieee1394/ieee1394_core.h b/drivers/ieee1394/ieee1394_core.h
> index 21d50f7..926ebb8 100644
> --- a/drivers/ieee1394/ieee1394_core.h
> +++ b/drivers/ieee1394/ieee1394_core.h
> @@ -69,7 +69,7 @@ struct hpsb_packet {
>  	size_t header_size;		/* as filled in, not counting the CRC */
>  
>  	/* Buffers */
> -	quadlet_t *data;		/* can be DMA-mapped */
> +	__be32 *data;		/* can be DMA-mapped */
>  	quadlet_t header[5];
>  	quadlet_t embedded_data[0];	/* keep as last member */
>  };
> diff --git a/drivers/ieee1394/ieee1394_transactions.c b/drivers/ieee1394/ieee1394_transactions.c
> index 24021d2..4b54d22 100644
> --- a/drivers/ieee1394/ieee1394_transactions.c
> +++ b/drivers/ieee1394/ieee1394_transactions.c
> @@ -60,7 +60,7 @@ static void fill_async_readblock(struct hpsb_packet *packet, u64 addr,
>  }
>  
>  static void fill_async_writequad(struct hpsb_packet *packet, u64 addr,
> -				 quadlet_t data)
> +				 __be32 data)
>  {
>  	PREP_ASYNC_HEAD_ADDRESS(TCODE_WRITEQ);
>  	packet->header[3] = data;
> @@ -312,7 +312,7 @@ struct hpsb_packet *hpsb_make_readpacket(struct hpsb_host *host, nodeid_t node,
>  }
>  
>  struct hpsb_packet *hpsb_make_writepacket(struct hpsb_host *host, nodeid_t node,
> -					  u64 addr, quadlet_t * buffer,
> +					  u64 addr, __be32 * buffer,
>  					  size_t length)
>  {
>  	struct hpsb_packet *packet;
> @@ -493,7 +493,7 @@ struct hpsb_packet *hpsb_make_phypacket(struct hpsb_host *host, quadlet_t data)
>   * to avoid sending packets to the wrong nodes when we race with a bus reset.
>   */
>  int hpsb_read(struct hpsb_host *host, nodeid_t node, unsigned int generation,
> -	      u64 addr, quadlet_t * buffer, size_t length)
> +	      u64 addr, __be32 *buffer, size_t length)
>  {
>  	struct hpsb_packet *packet;
>  	int retval = 0;
> @@ -542,7 +542,7 @@ int hpsb_read(struct hpsb_host *host, nodeid_t node, unsigned int generation,
>   * to avoid sending packets to the wrong nodes when we race with a bus reset.
>   */
>  int hpsb_write(struct hpsb_host *host, nodeid_t node, unsigned int generation,
> -	       u64 addr, quadlet_t * buffer, size_t length)
> +	       u64 addr, __be32 *buffer, size_t length)
>  {
>  	struct hpsb_packet *packet;
>  	int retval;
> diff --git a/drivers/ieee1394/ieee1394_transactions.h b/drivers/ieee1394/ieee1394_transactions.h
> index 20b693b..bdf7fd7 100644
> --- a/drivers/ieee1394/ieee1394_transactions.h
> +++ b/drivers/ieee1394/ieee1394_transactions.h
> @@ -21,15 +21,15 @@ struct hpsb_packet *hpsb_make_lock64packet(struct hpsb_host *host,
>  struct hpsb_packet *hpsb_make_phypacket(struct hpsb_host *host, quadlet_t data);
>  struct hpsb_packet *hpsb_make_writepacket(struct hpsb_host *host,
>  					  nodeid_t node, u64 addr,
> -					  quadlet_t *buffer, size_t length);
> +					  __be32 *buffer, size_t length);
>  struct hpsb_packet *hpsb_make_streampacket(struct hpsb_host *host, u8 *buffer,
>                                             int length, int channel, int tag,
>  					   int sync);
>  int hpsb_packet_success(struct hpsb_packet *packet);
>  int hpsb_read(struct hpsb_host *host, nodeid_t node, unsigned int generation,
> -	      u64 addr, quadlet_t *buffer, size_t length);
> +	      u64 addr, __be32 *buffer, size_t length);
>  int hpsb_write(struct hpsb_host *host, nodeid_t node, unsigned int generation,
> -	       u64 addr, quadlet_t *buffer, size_t length);
> +	       u64 addr, __be32 *buffer, size_t length);
>  int hpsb_lock(struct hpsb_host *host, nodeid_t node, unsigned int generation,
>  	      u64 addr, int extcode, quadlet_t *data, quadlet_t arg);
>  
> diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
> index bf2904a..9638d00 100644
> --- a/drivers/ieee1394/nodemgr.c
> +++ b/drivers/ieee1394/nodemgr.c
> @@ -50,9 +50,9 @@ struct nodemgr_csr_info {
>   * A possible speed is determined by trial and error, using quadlet reads.
>   */
>  static int nodemgr_check_speed(struct nodemgr_csr_info *ci, u64 addr,
> -			       quadlet_t *buffer)
> +			       __be32 *buffer)
>  {
> -	quadlet_t q;
> +	__be32 q;
>  	u8 i, *speed, old_speed, good_speed;
>  	int error;
>  
> @@ -115,7 +115,7 @@ static int nodemgr_bus_read(struct csr1212_csr *csr, u64 addr, u16 length,
>  	return error;
>  }
>  
> -static int nodemgr_get_max_rom(quadlet_t *bus_info_data, void *__ci)
> +static int nodemgr_get_max_rom(__be32 *bus_info_data, void *__ci)
>  {
>  	return (be32_to_cpu(bus_info_data[2]) >> 8) & 0x3;
>  }
> @@ -1425,7 +1425,7 @@ static void nodemgr_update_pdrv(struct node_entry *ne)
>  static void nodemgr_irm_write_bc(struct node_entry *ne, int generation)
>  {
>  	const u64 bc_addr = (CSR_REGISTER_BASE | CSR_BROADCAST_CHANNEL);
> -	quadlet_t bc_remote, bc_local;
> +	__be32 bc_remote, bc_local;
>  	int error;
>  
>  	if (!ne->host->is_irm || ne->generation != generation ||
> @@ -1574,7 +1574,7 @@ static int nodemgr_send_resume_packet(struct hpsb_host *host)
>  /* Perform a few high-level IRM responsibilities. */
>  static int nodemgr_do_irm_duties(struct hpsb_host *host, int cycles)
>  {
> -	quadlet_t bc;
> +	__be32 bc;
>  
>  	/* if irm_id == -1 then there is no IRM on this bus */
>  	if (!host->is_irm || host->irm_id == (nodeid_t)-1)
> @@ -1629,7 +1629,7 @@ static int nodemgr_do_irm_duties(struct hpsb_host *host, int cycles)
>   * ourselves. */
>  static int nodemgr_check_irm_capability(struct hpsb_host *host, int cycles)
>  {
> -	quadlet_t bc;
> +	__be32 bc;
>  	int status;
>  
>  	if (hpsb_disable_irm || host->is_irm)
> @@ -1811,7 +1811,7 @@ void hpsb_node_fill_packet(struct node_entry *ne, struct hpsb_packet *packet)
>  }
>  
>  int hpsb_node_write(struct node_entry *ne, u64 addr,
> -		    quadlet_t *buffer, size_t length)
> +		    __be32 *buffer, size_t length)
>  {
>  	unsigned int generation = ne->generation;
>  
> diff --git a/drivers/ieee1394/nodemgr.h b/drivers/ieee1394/nodemgr.h
> index d9391ef..943d6f3 100644
> --- a/drivers/ieee1394/nodemgr.h
> +++ b/drivers/ieee1394/nodemgr.h
> @@ -158,7 +158,7 @@ static inline int hpsb_node_entry_valid(struct node_entry *ne)
>  }
>  void hpsb_node_fill_packet(struct node_entry *ne, struct hpsb_packet *packet);
>  int hpsb_node_write(struct node_entry *ne, u64 addr,
> -		    quadlet_t *buffer, size_t length);
> +		    __be32 *buffer, size_t length);
>  static inline int hpsb_node_read(struct node_entry *ne, u64 addr,
>  				 quadlet_t *buffer, size_t length)
>  {
> diff --git a/drivers/ieee1394/ohci1394.c b/drivers/ieee1394/ohci1394.c
> index e509e13..106a544 100644
> --- a/drivers/ieee1394/ohci1394.c
> +++ b/drivers/ieee1394/ohci1394.c
> @@ -2973,7 +2973,7 @@ alloc_dma_trm_ctx(struct ti_ohci *ohci, struct dma_trm_ctx *d,
>  	return 0;
>  }
>  
> -static void ohci_set_hw_config_rom(struct hpsb_host *host, quadlet_t *config_rom)
> +static void ohci_set_hw_config_rom(struct hpsb_host *host, __be32 *config_rom)
>  {
>  	struct ti_ohci *ohci = host->hostdata;
>  
> diff --git a/drivers/ieee1394/ohci1394.h b/drivers/ieee1394/ohci1394.h
> index 4320bf0..331ab2d 100644
> --- a/drivers/ieee1394/ohci1394.h
> +++ b/drivers/ieee1394/ohci1394.h
> @@ -58,10 +58,10 @@
>  #define OHCI1394_PCI_HCI_Control 0x40
>  
>  struct dma_cmd {
> -        u32 control;
> -        u32 address;
> -        u32 branchAddress;
> -        u32 status;
> +	__le32 control;
> +	__le32 address;
> +	__le32 branchAddress;
> +	__le32 status;
>  };
>  
>  /*
> diff --git a/drivers/ieee1394/pcilynx.h b/drivers/ieee1394/pcilynx.h
> index ec27321..693a169 100644
> --- a/drivers/ieee1394/pcilynx.h
> +++ b/drivers/ieee1394/pcilynx.h
> @@ -52,7 +52,7 @@ struct ti_lynx {
>          void __iomem *local_rom;
>          void __iomem *local_ram;
>          void __iomem *aux_port;
> -	quadlet_t bus_info_block[5];
> +	__be32 bus_info_block[5];
>  
>          /*
>           * use local RAM of LOCALRAM_SIZE bytes for PCLs, which allows for
> diff --git a/drivers/ieee1394/raw1394.c b/drivers/ieee1394/raw1394.c
> index bf7e761..8a3079b 100644
> --- a/drivers/ieee1394/raw1394.c
> +++ b/drivers/ieee1394/raw1394.c
> @@ -80,15 +80,15 @@ static const int iso_buffer_max = 4 * 1024 * 1024;	/* 4 MB */
>  
>  static struct hpsb_highlevel raw1394_highlevel;
>  
> -static int arm_read(struct hpsb_host *host, int nodeid, quadlet_t * buffer,
> +static int arm_read(struct hpsb_host *host, int nodeid, __be32 *buffer,
>  		    u64 addr, size_t length, u16 flags);
>  static int arm_write(struct hpsb_host *host, int nodeid, int destid,
> -		     quadlet_t * data, u64 addr, size_t length, u16 flags);
> -static int arm_lock(struct hpsb_host *host, int nodeid, quadlet_t * store,
> -		    u64 addr, quadlet_t data, quadlet_t arg, int ext_tcode,
> +		     __be32 *data, u64 addr, size_t length, u16 flags);
> +static int arm_lock(struct hpsb_host *host, int nodeid, __be32 *store,
> +		    u64 addr, __be32 data, __be32 arg, int ext_tcode,
>  		    u16 flags);
> -static int arm_lock64(struct hpsb_host *host, int nodeid, octlet_t * store,
> -		      u64 addr, octlet_t data, octlet_t arg, int ext_tcode,
> +static int arm_lock64(struct hpsb_host *host, int nodeid, __be64 *store,
> +		      u64 addr, __be64 data, __be64 arg, int ext_tcode,
>  		      u16 flags);
>  static struct hpsb_address_ops arm_ops = {
>  	.read = arm_read,
> @@ -845,7 +845,7 @@ static int handle_async_send(struct file_info *fi, struct pending_request *req)
>  	return 0;
>  }
>  
> -static int arm_read(struct hpsb_host *host, int nodeid, quadlet_t * buffer,
> +static int arm_read(struct hpsb_host *host, int nodeid, __be32 *buffer,
>  		    u64 addr, size_t length, u16 flags)
>  {
>  	unsigned long irqflags;
> @@ -1000,7 +1000,7 @@ static int arm_read(struct hpsb_host *host, int nodeid, quadlet_t * buffer,
>  }
>  
>  static int arm_write(struct hpsb_host *host, int nodeid, int destid,
> -		     quadlet_t * data, u64 addr, size_t length, u16 flags)
> +		     __be32 *data, u64 addr, size_t length, u16 flags)
>  {
>  	unsigned long irqflags;
>  	struct pending_request *req;
> @@ -1134,8 +1134,8 @@ static int arm_write(struct hpsb_host *host, int nodeid, int destid,
>  	return (rcode);
>  }
>  
> -static int arm_lock(struct hpsb_host *host, int nodeid, quadlet_t * store,
> -		    u64 addr, quadlet_t data, quadlet_t arg, int ext_tcode,
> +static int arm_lock(struct hpsb_host *host, int nodeid, __be32 *store,
> +		    u64 addr, __be32 data, __be32 arg, int ext_tcode,
>  		    u16 flags)
>  {
>  	unsigned long irqflags;
> @@ -1147,7 +1147,7 @@ static int arm_lock(struct hpsb_host *host, int nodeid, quadlet_t * store,
>  	struct arm_request *arm_req = NULL;
>  	struct arm_response *arm_resp = NULL;
>  	int found = 0, size = 0, rcode = -1;
> -	quadlet_t old, new;
> +	__be32 old, new;
>  	struct arm_request_response *arm_req_resp = NULL;
>  
>  	if (((ext_tcode & 0xFF) == EXTCODE_FETCH_ADD) ||
> @@ -1220,9 +1220,9 @@ static int arm_lock(struct hpsb_host *host, int nodeid, quadlet_t * store,
>  							be32_to_cpu(old));
>  					break;
>  				case (EXTCODE_LITTLE_ADD):
> -					new =
> -					    cpu_to_le32(le32_to_cpu(data) +
> -							le32_to_cpu(old));
> +					new = (__force __be32)cpu_to_le32(
> +					    le32_to_cpu((__force __le32)data) +
> +					    le32_to_cpu((__force __le32)old));
>  					break;
>  				case (EXTCODE_BOUNDED_ADD):
>  					if (old != arg) {
> @@ -1352,8 +1352,8 @@ static int arm_lock(struct hpsb_host *host, int nodeid, quadlet_t * store,
>  	return (rcode);
>  }
>  
> -static int arm_lock64(struct hpsb_host *host, int nodeid, octlet_t * store,
> -		      u64 addr, octlet_t data, octlet_t arg, int ext_tcode,
> +static int arm_lock64(struct hpsb_host *host, int nodeid, __be64 *store,
> +		      u64 addr, __be64 data, __be64 arg, int ext_tcode,
>  		      u16 flags)
>  {
>  	unsigned long irqflags;
> @@ -1365,7 +1365,7 @@ static int arm_lock64(struct hpsb_host *host, int nodeid, octlet_t * store,
>  	struct arm_request *arm_req = NULL;
>  	struct arm_response *arm_resp = NULL;
>  	int found = 0, size = 0, rcode = -1;
> -	octlet_t old, new;
> +	__be64 old, new;
>  	struct arm_request_response *arm_req_resp = NULL;
>  
>  	if (((ext_tcode & 0xFF) == EXTCODE_FETCH_ADD) ||
> @@ -1446,9 +1446,9 @@ static int arm_lock64(struct hpsb_host *host, int nodeid, octlet_t * store,
>  							be64_to_cpu(old));
>  					break;
>  				case (EXTCODE_LITTLE_ADD):
> -					new =
> -					    cpu_to_le64(le64_to_cpu(data) +
> -							le64_to_cpu(old));
> +					new = (__force __be64)cpu_to_le64(
> +					    le64_to_cpu((__force __le64)data) +
> +					    le64_to_cpu((__force __le64)old));
>  					break;
>  				case (EXTCODE_BOUNDED_ADD):
>  					if (old != arg) {
> @@ -1947,7 +1947,7 @@ static int write_phypacket(struct file_info *fi, struct pending_request *req)
>  	quadlet_t data;
>  	unsigned long flags;
>  
> -	data = be32_to_cpu((u32) req->req.sendb);
> +	data = be32_to_cpu(req->req.sendb);
>  	DBGMSG("write_phypacket called - quadlet 0x%8.8x ", data);
>  	packet = hpsb_make_phypacket(fi->host, data);
>  	if (!packet)
> diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
> index c52f6e6..ac99370 100644
> --- a/drivers/ieee1394/sbp2.c
> +++ b/drivers/ieee1394/sbp2.c
> @@ -247,7 +247,7 @@ static int sbp2_login_device(struct sbp2_lu *);
>  static int sbp2_reconnect_device(struct sbp2_lu *);
>  static int sbp2_logout_device(struct sbp2_lu *);
>  static void sbp2_host_reset(struct hpsb_host *);
> -static int sbp2_handle_status_write(struct hpsb_host *, int, int, quadlet_t *,
> +static int sbp2_handle_status_write(struct hpsb_host *, int, int, __be32 *,
>  				    u64, size_t, u16);
>  static int sbp2_agent_reset(struct sbp2_lu *, int);
>  static void sbp2_parse_unit_directory(struct sbp2_lu *,
> @@ -270,9 +270,9 @@ static struct hpsb_address_ops sbp2_ops = {
>  };
>  
>  #ifdef CONFIG_IEEE1394_SBP2_PHYS_DMA
> -static int sbp2_handle_physdma_write(struct hpsb_host *, int, int, quadlet_t *,
> +static int sbp2_handle_physdma_write(struct hpsb_host *, int, int, __be32 *,
>  				     u64, size_t, u16);
> -static int sbp2_handle_physdma_read(struct hpsb_host *, int, quadlet_t *, u64,
> +static int sbp2_handle_physdma_read(struct hpsb_host *, int, __be32 *, u64,
>  				    size_t, u16);
>  
>  static struct hpsb_address_ops sbp2_physdma_ops = {
> @@ -416,18 +416,6 @@ static const struct {
>   * General utility functions
>   **************************************/
>  
> -#ifndef __BIG_ENDIAN
> -/*
> - * Converts a buffer from be32 to cpu byte ordering. Length is in bytes.
> - */
> -static inline void sbp2util_be32_to_cpu_buffer(void *buffer, int length)
> -{
> -	u32 *temp = buffer;
> -
> -	for (length = (length >> 2); length--; )
> -		temp[length] = be32_to_cpu(temp[length]);
> -}
> -
>  /*
>   * Converts a buffer from cpu to be32 byte ordering. Length is in bytes.
>   */
> @@ -436,13 +424,8 @@ static inline void sbp2util_cpu_to_be32_buffer(void *buffer, int length)
>  	u32 *temp = buffer;
>  
>  	for (length = (length >> 2); length--; )
> -		temp[length] = cpu_to_be32(temp[length]);
> +		cpu_to_be32s(temp + length);
>  }
> -#else /* BIG_ENDIAN */
> -/* Why waste the cpu cycles? */
> -#define sbp2util_be32_to_cpu_buffer(x,y) do {} while (0)
> -#define sbp2util_cpu_to_be32_buffer(x,y) do {} while (0)
> -#endif
>  
>  static DECLARE_WAIT_QUEUE_HEAD(sbp2_access_wq);
>  
> @@ -471,7 +454,7 @@ static void sbp2_free_packet(void *packet)
>   * subaction and returns immediately. Can be used from atomic context.
>   */
>  static int sbp2util_node_write_no_wait(struct node_entry *ne, u64 addr,
> -				       quadlet_t *buf, size_t len)
> +				       __be32 *buf, size_t len)
>  {
>  	struct hpsb_packet *packet;
>  
> @@ -489,7 +472,7 @@ static int sbp2util_node_write_no_wait(struct node_entry *ne, u64 addr,
>  }
>  
>  static void sbp2util_notify_fetch_agent(struct sbp2_lu *lu, u64 offset,
> -					quadlet_t *data, size_t len)
> +					__be32 *data, size_t len)
>  {
>  	/* There is a small window after a bus reset within which the node
>  	 * entry's generation is current but the reconnect wasn't completed. */
> @@ -509,11 +492,10 @@ static void sbp2util_notify_fetch_agent(struct sbp2_lu *lu, u64 offset,
>  static void sbp2util_write_orb_pointer(struct work_struct *work)
>  {
>  	struct sbp2_lu *lu = container_of(work, struct sbp2_lu, protocol_work);
> -	quadlet_t data[2];
> +	__be32 data[2];
>  
> -	data[0] = ORB_SET_NODE_ID(lu->hi->host->node_id);
> -	data[1] = lu->last_orb_dma;
> -	sbp2util_cpu_to_be32_buffer(data, 8);
> +	data[0] = cpu_to_be32(ORB_SET_NODE_ID(lu->hi->host->node_id));
> +	data[1] = cpu_to_be32(lu->last_orb_dma);
>  	sbp2util_notify_fetch_agent(lu, SBP2_ORB_POINTER_OFFSET, data, 8);
>  }
>  
> @@ -1048,7 +1030,7 @@ no_hi:
>   * have it switched off.
>   */
>  static int sbp2_handle_physdma_write(struct hpsb_host *host, int nodeid,
> -				     int destid, quadlet_t *data, u64 addr,
> +				     int destid, __be32 *data, u64 addr,
>  				     size_t length, u16 flags)
>  {
>  	memcpy(bus_to_virt((u32) addr), data, length);
> @@ -1060,7 +1042,7 @@ static int sbp2_handle_physdma_write(struct hpsb_host *host, int nodeid,
>   * have it switched off.
>   */
>  static int sbp2_handle_physdma_read(struct hpsb_host *host, int nodeid,
> -				    quadlet_t *data, u64 addr, size_t length,
> +				    __be32 *data, u64 addr, size_t length,
>  				    u16 flags)
>  {
>  	memcpy(data, bus_to_virt((u32) addr), length);
> @@ -1075,7 +1057,7 @@ static int sbp2_handle_physdma_read(struct hpsb_host *host, int nodeid,
>  static int sbp2_query_logins(struct sbp2_lu *lu)
>  {
>  	struct sbp2_fwhost_info *hi = lu->hi;
> -	quadlet_t data[2];
> +	__be32 data[2];
>  	int max_logins;
>  	int active_logins;
>  
> @@ -1105,9 +1087,8 @@ static int sbp2_query_logins(struct sbp2_lu *lu)
>  	memset(lu->query_logins_response, 0,
>  	       sizeof(struct sbp2_query_logins_response));
>  
> -	data[0] = ORB_SET_NODE_ID(hi->host->node_id);
> -	data[1] = lu->query_logins_orb_dma;
> -	sbp2util_cpu_to_be32_buffer(data, 8);
> +	data[0] = cpu_to_be32(ORB_SET_NODE_ID(hi->host->node_id));
> +	data[1] = cpu_to_be32(lu->query_logins_orb_dma);
>  
>  	hpsb_node_write(lu->ne, lu->management_agent_addr, data, 8);
>  
> @@ -1147,7 +1128,7 @@ static int sbp2_query_logins(struct sbp2_lu *lu)
>  static int sbp2_login_device(struct sbp2_lu *lu)
>  {
>  	struct sbp2_fwhost_info *hi = lu->hi;
> -	quadlet_t data[2];
> +	__be32 data[2];
>  
>  	if (!lu->login_orb)
>  		return -EIO;
> @@ -1184,9 +1165,8 @@ static int sbp2_login_device(struct sbp2_lu *lu)
>  
>  	memset(lu->login_response, 0, sizeof(struct sbp2_login_response));
>  
> -	data[0] = ORB_SET_NODE_ID(hi->host->node_id);
> -	data[1] = lu->login_orb_dma;
> -	sbp2util_cpu_to_be32_buffer(data, 8);
> +	data[0] = cpu_to_be32(ORB_SET_NODE_ID(hi->host->node_id));
> +	data[1] = cpu_to_be32(lu->login_orb_dma);
>  
>  	hpsb_node_write(lu->ne, lu->management_agent_addr, data, 8);
>  
> @@ -1222,7 +1202,7 @@ static int sbp2_login_device(struct sbp2_lu *lu)
>  static int sbp2_logout_device(struct sbp2_lu *lu)
>  {
>  	struct sbp2_fwhost_info *hi = lu->hi;
> -	quadlet_t data[2];
> +	__be32 data[2];
>  	int error;
>  
>  	lu->logout_orb->reserved1 = 0x0;
> @@ -1244,9 +1224,8 @@ static int sbp2_logout_device(struct sbp2_lu *lu)
>  	sbp2util_cpu_to_be32_buffer(lu->logout_orb,
>  				    sizeof(struct sbp2_logout_orb));
>  
> -	data[0] = ORB_SET_NODE_ID(hi->host->node_id);
> -	data[1] = lu->logout_orb_dma;
> -	sbp2util_cpu_to_be32_buffer(data, 8);
> +	data[0] = cpu_to_be32(ORB_SET_NODE_ID(hi->host->node_id));
> +	data[1] = cpu_to_be32(lu->logout_orb_dma);
>  
>  	error = hpsb_node_write(lu->ne, lu->management_agent_addr, data, 8);
>  	if (error)
> @@ -1263,7 +1242,7 @@ static int sbp2_logout_device(struct sbp2_lu *lu)
>  static int sbp2_reconnect_device(struct sbp2_lu *lu)
>  {
>  	struct sbp2_fwhost_info *hi = lu->hi;
> -	quadlet_t data[2];
> +	__be32 data[2];
>  	int error;
>  
>  	lu->reconnect_orb->reserved1 = 0x0;
> @@ -1286,9 +1265,8 @@ static int sbp2_reconnect_device(struct sbp2_lu *lu)
>  	sbp2util_cpu_to_be32_buffer(lu->reconnect_orb,
>  				    sizeof(struct sbp2_reconnect_orb));
>  
> -	data[0] = ORB_SET_NODE_ID(hi->host->node_id);
> -	data[1] = lu->reconnect_orb_dma;
> -	sbp2util_cpu_to_be32_buffer(data, 8);
> +	data[0] = cpu_to_be32(ORB_SET_NODE_ID(hi->host->node_id));
> +	data[1] = cpu_to_be32(lu->reconnect_orb_dma);
>  
>  	error = hpsb_node_write(lu->ne, lu->management_agent_addr, data, 8);
>  	if (error)
> @@ -1321,7 +1299,7 @@ static int sbp2_reconnect_device(struct sbp2_lu *lu)
>   */
>  static int sbp2_set_busy_timeout(struct sbp2_lu *lu)
>  {
> -	quadlet_t data;
> +	__be32 data;
>  
>  	data = cpu_to_be32(SBP2_BUSY_TIMEOUT_VALUE);
>  	if (hpsb_node_write(lu->ne, SBP2_BUSY_TIMEOUT_ADDRESS, &data, 4))
> @@ -1470,7 +1448,7 @@ static int sbp2_max_speed_and_size(struct sbp2_lu *lu)
>  
>  static int sbp2_agent_reset(struct sbp2_lu *lu, int wait)
>  {
> -	quadlet_t data;
> +	__be32 data;
>  	u64 addr;
>  	int retval;
>  	unsigned long flags;
> @@ -1479,7 +1457,7 @@ static int sbp2_agent_reset(struct sbp2_lu *lu, int wait)
>  	if (wait)
>  		flush_scheduled_work();
>  
> -	data = ntohl(SBP2_AGENT_RESET_DATA);
> +	data = htonl(SBP2_AGENT_RESET_DATA);
>  	addr = lu->command_block_agent_addr + SBP2_AGENT_RESET_OFFSET;
>  
>  	if (wait)
> @@ -1516,13 +1494,13 @@ static int sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
>  	if (n == 0)
>  		return -ENOMEM;
>  
> -	orb->data_descriptor_hi = ORB_SET_NODE_ID(hi->host->node_id);
> -	orb->misc |= ORB_SET_DIRECTION(orb_direction);
> +	orb->data_descriptor_hi = cpu_to_be32(ORB_SET_NODE_ID(hi->host->node_id));
> +	orb->misc |= cpu_to_be32(ORB_SET_DIRECTION(orb_direction));
>  
>  	/* special case if only one element (and less than 64KB in size) */
>  	if (n == 1) {
> -		orb->misc |= ORB_SET_DATA_SIZE(sg_dma_len(sg));
> -		orb->data_descriptor_lo = sg_dma_address(sg);
> +		orb->misc |= cpu_to_be32(ORB_SET_DATA_SIZE(sg_dma_len(sg)));
> +		orb->data_descriptor_lo = cpu_to_be32(sg_dma_address(sg));
>  	} else {
>  		pt = &cmd->scatter_gather_element[0];
>  
> @@ -1535,9 +1513,9 @@ static int sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
>  			pt[i].low = cpu_to_be32(sg_dma_address(sg));
>  		}
>  
> -		orb->misc |= ORB_SET_PAGE_TABLE_PRESENT(0x1) |
> -			     ORB_SET_DATA_SIZE(n);
> -		orb->data_descriptor_lo = cmd->sge_dma;
> +		orb->misc |= cpu_to_be32(ORB_SET_PAGE_TABLE_PRESENT(0x1) |
> +					 ORB_SET_DATA_SIZE(n));
> +		orb->data_descriptor_lo = cpu_to_be32(cmd->sge_dma);
>  
>  		dma_sync_single_for_device(dmadev, cmd->sge_dma,
>  					   sizeof(cmd->scatter_gather_element),
> @@ -1567,11 +1545,11 @@ static int sbp2_create_command_orb(struct sbp2_lu *lu,
>  	 * that data_size becomes the number of s/g elements, and
>  	 * page_size should be zero (for unrestricted).
>  	 */
> -	orb->next_ORB_hi = ORB_SET_NULL_PTR(1);
> -	orb->next_ORB_lo = 0x0;
> -	orb->misc = ORB_SET_MAX_PAYLOAD(lu->max_payload_size);
> -	orb->misc |= ORB_SET_SPEED(lu->speed_code);
> -	orb->misc |= ORB_SET_NOTIFY(1);
> +	orb->next_ORB_hi = cpu_to_be32(ORB_SET_NULL_PTR(1));
> +	orb->next_ORB_lo = cpu_to_be32(0x0);
> +	orb->misc = cpu_to_be32(ORB_SET_MAX_PAYLOAD(lu->max_payload_size));
> +	orb->misc |= cpu_to_be32(ORB_SET_SPEED(lu->speed_code));
> +	orb->misc |= cpu_to_be32(ORB_SET_NOTIFY(1));
>  
>  	if (dma_dir == DMA_NONE)
>  		orb_direction = ORB_DIRECTION_NO_DATA_TRANSFER;
> @@ -1586,9 +1564,9 @@ static int sbp2_create_command_orb(struct sbp2_lu *lu,
>  
>  	/* set up our page table stuff */
>  	if (orb_direction == ORB_DIRECTION_NO_DATA_TRANSFER) {
> -		orb->data_descriptor_hi = 0x0;
> -		orb->data_descriptor_lo = 0x0;
> -		orb->misc |= ORB_SET_DIRECTION(1);
> +		orb->data_descriptor_hi = cpu_to_be32(0x0);
> +		orb->data_descriptor_lo = cpu_to_be32(0x0);
> +		orb->misc |= cpu_to_be32(ORB_SET_DIRECTION(1));
>  		ret = 0;
>  	} else {
>  		ret = sbp2_prep_command_orb_sg(orb, lu->hi, cmd,
> @@ -1596,7 +1574,6 @@ static int sbp2_create_command_orb(struct sbp2_lu *lu,
>  					       scsi_sglist(SCpnt),
>  					       orb_direction, dma_dir);
>  	}
> -	sbp2util_cpu_to_be32_buffer(orb, sizeof(*orb));
>  
>  	memset(orb->cdb, 0, sizeof(orb->cdb));
>  	memcpy(orb->cdb, SCpnt->cmnd, SCpnt->cmd_len);
> @@ -1613,7 +1590,7 @@ static void sbp2_link_orb_command(struct sbp2_lu *lu,
>  	struct sbp2_command_orb *last_orb;
>  	dma_addr_t last_orb_dma;
>  	u64 addr = lu->command_block_agent_addr;
> -	quadlet_t data[2];
> +	__be32 data[2];
>  	size_t length;
>  	unsigned long flags;
>  
> @@ -1627,9 +1604,8 @@ static void sbp2_link_orb_command(struct sbp2_lu *lu,
>  		 * is not active right now.
>  		 */
>  		addr += SBP2_ORB_POINTER_OFFSET;
> -		data[0] = ORB_SET_NODE_ID(hi->host->node_id);
> -		data[1] = cmd->command_orb_dma;
> -		sbp2util_cpu_to_be32_buffer(data, 8);
> +		data[0] = cpu_to_be32(ORB_SET_NODE_ID(hi->host->node_id));
> +		data[1] = cpu_to_be32(cmd->command_orb_dma);
>  		length = 8;
>  	} else {
>  		/*
> @@ -1651,7 +1627,7 @@ static void sbp2_link_orb_command(struct sbp2_lu *lu,
>  					   sizeof(struct sbp2_command_orb),
>  					   DMA_TO_DEVICE);
>  		addr += SBP2_DOORBELL_OFFSET;
> -		data[0] = 0;
> +		data[0] = cpu_to_be32(0);
>  		length = 4;
>  	}
>  	lu->last_orb = &cmd->command_orb;
> @@ -1719,7 +1695,7 @@ static unsigned int sbp2_status_to_sense_data(unchar *sbp2_status,
>  }
>  
>  static int sbp2_handle_status_write(struct hpsb_host *host, int nodeid,
> -				    int destid, quadlet_t *data, u64 addr,
> +				    int destid, __be32 *data, u64 addr,
>  				    size_t length, u16 fl)
>  {
>  	struct sbp2_fwhost_info *hi;
> @@ -1765,9 +1741,10 @@ static int sbp2_handle_status_write(struct hpsb_host *host, int nodeid,
>  	 * truncated status block, minimally the first two quadlets. The rest
>  	 * is implied to be zeros. */
>  	sb = &lu->status_block;
> +	sb->ORB_offset_hi_misc = be32_to_cpu(sb->ORB_offset_hi_misc);
> +	sb->ORB_offset_lo = be32_to_cpu(sb->ORB_offset_lo);
>  	memset(sb->command_set_dependent, 0, sizeof(sb->command_set_dependent));
>  	memcpy(sb, data, length);
> -	sbp2util_be32_to_cpu_buffer(sb, 8);
>  
>  	/* Ignore unsolicited status. Handle command ORB status. */
>  	if (unlikely(STATUS_GET_SRC(sb->ORB_offset_hi_misc) == 2))
> diff --git a/drivers/ieee1394/sbp2.h b/drivers/ieee1394/sbp2.h
> index c5036f1..92d47c6 100644
> --- a/drivers/ieee1394/sbp2.h
> +++ b/drivers/ieee1394/sbp2.h
> @@ -46,11 +46,11 @@
>  #define ORB_SET_DIRECTION(v)		(((v) & 0x1) << 27)
>  
>  struct sbp2_command_orb {
> -	u32 next_ORB_hi;
> -	u32 next_ORB_lo;
> -	u32 data_descriptor_hi;
> -	u32 data_descriptor_lo;
> -	u32 misc;
> +	__be32 next_ORB_hi;
> +	__be32 next_ORB_lo;
> +	__be32 data_descriptor_hi;
> +	__be32 data_descriptor_lo;
> +	__be32 misc;
>  	u8 cdb[12];
>  } __attribute__((packed));
>  
> diff --git a/drivers/ieee1394/video1394.c b/drivers/ieee1394/video1394.c
> index 679a918..df681f6 100644
> --- a/drivers/ieee1394/video1394.c
> +++ b/drivers/ieee1394/video1394.c
> @@ -63,7 +63,7 @@
>  
>  struct it_dma_prg {
>  	struct dma_cmd begin;
> -	quadlet_t data[4];
> +	__le32 data[4];
>  	struct dma_cmd end;
>  	quadlet_t pad[4]; /* FIXME: quick hack for memory alignment */
>  };


-- 
Stefan Richter
-=====-==--- =-== -==--
http://arcgraph.de/sr/

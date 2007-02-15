Return-Path: <linux-kernel-owner+w=401wt.eu-S1161164AbXBOUWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161164AbXBOUWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161166AbXBOUWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:22:03 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:59404 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161164AbXBOUWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:22:01 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling
	updated	patch
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net
In-Reply-To: <200702151537.51202.arnd@arndb.de>
References: <1171497138.23691.8.camel@dyn9047021078.beaverton.ibm.com>
	 <200702151537.51202.arnd@arndb.de>
Content-Type: text/plain
Date: Thu, 15 Feb 2007 12:21:58 -0800
Message-Id: <1171570918.31179.36.camel@dyn9047021078.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 15:37 +0100, Arnd Bergmann wrote:
> On Thursday 15 February 2007 00:52, Carl Love wrote:
> 
> 
> > --- linux-2.6.20-rc1.orig/arch/powerpc/oprofile/Kconfig	2007-01-18 16:43:14.000000000 -0600
> > +++ linux-2.6.20-rc1/arch/powerpc/oprofile/Kconfig	2007-02-13 19:04:46.271028904 -0600
> > @@ -7,7 +7,8 @@
> >  
> >  config OPROFILE
> >  	tristate "OProfile system profiling (EXPERIMENTAL)"
> > -	depends on PROFILING
> > +	default m
> > +	depends on SPU_FS && PROFILING
> >  	help
> >  	  OProfile is a profiling system capable of profiling the
> >  	  whole system, include the kernel, kernel modules, libraries,
> 
> Milton already commented on this being wrong. I think what you want
> is
> 	depends on PROFILING && (SPU_FS = n || SPU_FS)
> 
> that should make sure that when SPU_FS=y that OPROFILE can not be 'm'.
> 
> > @@ -15,3 +16,10 @@
> >  
> >  	  If unsure, say N.
> >  
> > +config OPROFILE_CELL
> > +	bool "OProfile for Cell Broadband Engine"
> > +	depends on SPU_FS && OPROFILE
> > +	default y
> > +	help
> > +	  OProfile for Cell BE requires special support enabled
> > +	  by this option.
> 
> You should at least mention that this allows profiling the spus.
> 
> > +#define EFWCALL  ENOSYS         /* Use an existing error number that is as
> > +				 * close as possible for a FW call that failed.
> > +				 * The probability of the call failing is
> > +				 * very low.  Passing up the error number
> > +				 * ensures that the user will see an error
> > +				 * message saying OProfile did not start.
> > +				 * Dmesg will contain an accurate message
> > +				 * about the failure.
> > +				 */
> 
> ENOSYS looks wrong though. It would appear to the user as if the oprofile
> function in the kernel was not present. I'd suggest EIO, and not use 
> an extra define for that.
> 

OK, will do. 

> 
> >  static int
> >  rtas_ibm_cbe_perftools(int subfunc, int passthru,
> >  		       void *address, unsigned long length)
> >  {
> >  	u64 paddr = __pa(address);
> >  
> > -	return rtas_call(pm_rtas_token, 5, 1, NULL, subfunc, passthru,
> > -			 paddr >> 32, paddr & 0xffffffff, length);
> > +	pm_rtas_token = rtas_token("ibm,cbe-perftools");
> > +
> > +	if (unlikely(pm_rtas_token == RTAS_UNKNOWN_SERVICE)) {
> > +		printk(KERN_ERR
> > +		       "%s: rtas token ibm,cbe-perftools unknown\n",
> > +		       __FUNCTION__);
> > +		return -EFWCALL;
> > +	} else {
> > +
> > +		return rtas_call(pm_rtas_token, 5, 1, NULL, subfunc, 
> > +			 passthru, paddr >> 32, paddr & 0xffffffff, length); 
> > +	}
> >  }
> 
> Are you now reading the rtas token every time you call rtas? that seems
> like a waste of time.

There are actually two RTAS calls, i.e. two tokens.  Once for setting up
the debug bus.  The other to do the SPU PC collection.  Yes, we are
getting the token each time using the single global pm_rtas_token.  To
make sure we had the correct token, I made sure to call it each time.
As you point out it is very wasteful.  It probably would be best to just
have a second global variable say spu_rtas_token.  Then do a single call
for each global variable.  Then we just use the global variable in the
appropriate rtas_call.  This would eliminate a significant number of
calls to look up the token.  I should have thought of that earlier.  

> 
> 
> > +#define size 24
> > +#define ENTRIES  (0x1<<8) /* 256 */
> > +#define MAXLFSR  0xFFFFFF
> > +
> > +int initial_lfsr[] =
> > +{16777215, 3797240, 13519805, 11602690, 6497030, 7614675, 2328937, 2889445,
> > + 12364575, 8723156, 2450594, 16280864, 14742496, 10904589, 6434212, 4996256,
> > + 5814270, 13014041, 9825245, 410260, 904096, 15151047, 15487695, 3061843,
> > + 16482682, 7938572, 4893279, 9390321, 4320879, 5686402, 1711063, 10176714,
> > + 4512270, 1057359, 16700434, 5731602, 2070114, 16030890, 1208230, 15603106,
> > + 11857845, 6470172, 1362790, 7316876, 8534496, 1629197, 10003072, 1714539,
> > + 1814669, 7106700, 5427154, 3395151, 3683327, 12950450, 16620273, 12122372,
> > + 7194999, 9952750, 3608260, 13604295, 2266835, 14943567, 7079230, 777380,
> > + 4516801, 1737661, 8730333, 13796927, 3247181, 9950017, 3481896, 16527555,
> > + 13116123, 14505033, 9781119, 4860212, 7403253, 13264219, 12269980, 100120,
> > + 664506, 607795, 8274553, 13133688, 6215305, 13208866, 16439693, 3320753,
> > + 8773582, 13874619, 1784784, 4513501, 11002978, 9318515, 3038856, 14254582,
> > + 15484958, 15967857, 13504461, 13657322, 14724513, 13955736, 5695315, 7330509,
> > + 12630101, 6826854, 439712, 4609055, 13288878, 1309632, 4996398, 11392266,
> > + 793740, 7653789, 2472670, 14641200, 5164364, 5482529, 10415855, 1629108,
> > + 2012376, 13661123, 14655718, 9534083, 16637925, 2537745, 9787923, 12750103,
> > + 4660370, 3283461, 14862772, 7034955, 6679872, 8918232, 6506913, 103649,
> > + 6085577, 13324033, 14251613, 11058220, 11998181, 3100233, 468898, 7104918,
> > + 12498413, 14408165, 1208514, 15712321, 3088687, 14778333, 3632503, 11151952,
> > + 98896, 9159367, 8866146, 4780737, 4925758, 12362320, 4122783, 8543358,
> > + 7056879, 10876914, 6282881, 1686625, 5100373, 4573666, 9265515, 13593840,
> > + 5853060, 1188880, 4237111, 15765555, 14344137, 4608332, 6590210, 13745050,
> > + 10916568, 12340402, 7145275, 4417153, 2300360, 12079643, 7608534, 15238251,
> > + 4947424, 7014722, 3984546, 7168073, 10759589, 16293080, 3757181, 4577717,
> > + 5163790, 2488841, 4650617, 3650022, 5440654, 1814617, 6939232, 15540909,
> > + 501788, 1060986, 5058235, 5078222, 3734500, 10762065, 390862, 5172712,
> > + 1070780, 7904429, 1669757, 3439997, 2956788, 14944927, 12496638, 994152,
> > + 8901173, 11827497, 4268056, 15725859, 1694506, 5451950, 2892428, 1434298,
> > + 9048323, 13558747, 15083840, 8154495, 15830901, 391127, 14970070, 2451434,
> > + 2080347, 10775644, 14599429, 12540753, 4813943, 16140655, 2421772, 12724304,
> > + 12935733, 7206473, 5697333, 10328104, 2418008, 13547986, 284246, 1732363,
> > + 16375319, 8109554, 16372365, 14346072, 1835890, 13059499, 2442500, 4110674};
> > +
> > +/*
> > + * The hardware uses an LFSR counting sequence to determine when to capture
> > + * the SPU PCs.  The SPU PC capture is done when the LFSR sequence reaches the
> > + * last value in the sequence.  An LFSR sequence is like a puesdo random
> > + * number sequence where each number occurs once in the sequence but the
> > + * sequence is not in numerical order.  To reduce the calculation time, a
> > + * sequence of 256 precomputed values in the LFSR sequence are stored in a
> > + * table.  The nearest precomputed value is used as the initial point from
> > + * which to caculate the desired LFSR value that is n from the end of the
> > + * sequence.  The lookup table reduces the maximum number of iterations in
> > + * the loop from 2^24 to 2^16.
> > + */
> > +static int calculate_lfsr(int n)
> > +{
> > +  int i;
> > +
> > +  int start_lfsr_index;
> > +  unsigned int newlfsr0;
> > +  unsigned int lfsr = MAXLFSR;
> > +  unsigned int binsize = (MAXLFSR+1)/ENTRIES;
> > +  unsigned int howmany;
> > +
> > +  start_lfsr_index = (MAXLFSR - n) / binsize;
> > +  lfsr = initial_lfsr[start_lfsr_index];
> > +  howmany = (MAXLFSR - n) - (start_lfsr_index * (binsize));
> > +
> > +  for (i = 2; i < howmany+2; i++) {
> > +    newlfsr0 = (((lfsr >> (size - 1 - 0)) & 1) ^
> > +		((lfsr >> (size - 1 - 1)) & 1) ^
> > +		(((lfsr >> (size - 1 - 6)) & 1) ^
> > +		 ((lfsr >> (size - 1 - 23)) & 1)));
> > +
> > +    lfsr >>= 1;
> > +    lfsr = lfsr | (newlfsr0 << (size - 1));
> > +  }
> > +  return lfsr;
> > +}
> 
> I agree with Milton that it would be far nicer even to calculate
> the value from user space, but since you say that would
> violate the oprofile interface conventions, let's not go there.
> In order to make this code nicer on the user, you should probably
> insert a 'cond_resched()' somewhere in the loop, maybe every
> 500 iterations or so.
> 
> it also looks like there is whitespace damage in the code here.

I will double check on the whitespace damage.  I thought I had gotten
all that out.  

I have done some quick measurements.  The above method limits the loop
to at most 2^16 iterations.  Based on running the algorithm in user
space, it takes about 3ms of computation time to do the loop 2^16 times.

At the vary least, we need to put the resched in say every 10,000
iterations which would be about every 0.5ms.  Should we do a resched
more often?  

Additionally we could up the size of the table to 512 which would reduce
the maximum time to about 1.5ms.  What do people think about increasing
the table size?

A little more general discussion about the logarithmic algorithm and
limiting the range.  The hardware supports a 24 bit LFSR value. This
means the user can say is capture a sample every N cycles, where N is in
the range of 1 to 2^24.  The OProfile user tool enforces a minimum value
of N to make sure the overhead of OProfile doesn't bring the machine to
its knees.  The minimum values is not intended to guarantee the
performance impact of OProfile will not be significant.  It is left as
an exercise for the user to pick an N that will give minimal performance
impact.  We set the lower limit for N for SPU profiling to 100,000. This
is actually high enough that we don't seem to see much performance
impact when running OProfile.  If the user picked N=2^24 then for a
3.2GHz machine you would get about 200 samples per second on each node.
Where a sample consists of the PC value for all 8 SPUs on the node.  If
the user wanted to do a relatively long OProfile run, I can see where
they might use N=2^24 to avoid gathering too much data.  My gut feeling
is that the sampling frequency for N=2^24 is not low enough that someone
would never want to use it when doing long runs.  Hence, we should not
arbitrarily reduce the maximum value for N.  Although I would expect
that the typical value for N will be in the range of several hundred
thousand to a few million.

As for using a logarithmic spacing of the precomputed values, this
approach means that the space between the precomputed values at the high
end would be much larger then 2^14, assuming 256 precomputed values.
That means it could take much longer then 3ms to get the needed LFSR
value for a large N.  By evenly spacing the precomputed values, we can
ensure that for all N it will take less then 3ms to get the value.
Personally, I am more comfortable with a hard limit on the compute time
then a variable time that could get much bigger then the 1ms threshold
that Arnd wants for resched.  Any thoughts?

> 
> > +
> > +/* This interface allows a profiler (e.g., OProfile) to store
> > + * spu_context information needed for profiling, allowing it to
> > + * be saved across context save/restore operation.
> > + *
> > + * Assumes the caller has already incremented the ref count to
> > + * profile_info; then spu_context_destroy must call kref_put
> > + * on prof_info_kref.
> > + */
> > +void spu_set_profile_private(struct spu_context * ctx, void * profile_info,
> > +			     struct kref * prof_info_kref,
> > +			     void (* prof_info_release) (struct kref * kref))
> > +{
> > +	ctx->profile_private = profile_info;
> > +	ctx->prof_priv_kref = prof_info_kref;
> > +	ctx->prof_priv_release = prof_info_release;
> > +}
> > +EXPORT_SYMBOL_GPL(spu_set_profile_private);
> 
> I think you don't need the profile_private member here, if you just use
> container_of with ctx->prof_priv_kref in all users.
> 
> 	Arnd <><


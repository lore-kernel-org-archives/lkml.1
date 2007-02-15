Return-Path: <linux-kernel-owner+w=401wt.eu-S966007AbXBOQP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966007AbXBOQP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966024AbXBOQP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:15:28 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43451 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966007AbXBOQP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:15:27 -0500
Message-ID: <45D4870C.9070908@us.ibm.com>
Date: Thu, 15 Feb 2007 10:15:08 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       Carl Love <cel@us.ibm.com>
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated
 patch
References: <1171497138.23691.8.camel@dyn9047021078.beaverton.ibm.com> <200702151537.51202.arnd@arndb.de>
In-Reply-To: <200702151537.51202.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:

>On Thursday 15 February 2007 00:52, Carl Love wrote:
>
>
>  
>
>>--- linux-2.6.20-rc1.orig/arch/powerpc/oprofile/Kconfig	2007-01-18 16:43:14.000000000 -0600
>>+++ linux-2.6.20-rc1/arch/powerpc/oprofile/Kconfig	2007-02-13 19:04:46.271028904 -0600
>>@@ -7,7 +7,8 @@
>> 
>> config OPROFILE
>> 	tristate "OProfile system profiling (EXPERIMENTAL)"
>>-	depends on PROFILING
>>+	default m
>>+	depends on SPU_FS && PROFILING
>> 	help
>> 	  OProfile is a profiling system capable of profiling the
>> 	  whole system, include the kernel, kernel modules, libraries,
>>    
>>
>
>Milton already commented on this being wrong. I think what you want
>is
>	depends on PROFILING && (SPU_FS = n || SPU_FS)
>
>that should make sure that when SPU_FS=y that OPROFILE can not be 'm'.
>  
>
Blast it!  I did this right on our development system, but neglected to 
update the patch correctly to remove this dependency and 'default m'.  
I'll fix in the next patch.

>  
>
>>@@ -15,3 +16,10 @@
>> 
>> 	  If unsure, say N.
>> 
>>+config OPROFILE_CELL
>>+	bool "OProfile for Cell Broadband Engine"
>>+	depends on SPU_FS && OPROFILE
>>+	default y
>>+	help
>>+	  OProfile for Cell BE requires special support enabled
>>+	  by this option.
>>    
>>
>
>You should at least mention that this allows profiling the spus.
>  
>
OK.

>  
>
>>+#define EFWCALL  ENOSYS         /* Use an existing error number that is as
>>+				 * close as possible for a FW call that failed.
>>+				 * The probability of the call failing is
>>+				 * very low.  Passing up the error number
>>+				 * ensures that the user will see an error
>>+				 * message saying OProfile did not start.
>>+				 * Dmesg will contain an accurate message
>>+				 * about the failure.
>>+				 */
>>    
>>
>
>ENOSYS looks wrong though. It would appear to the user as if the oprofile
>function in the kernel was not present. I'd suggest EIO, and not use 
>an extra define for that.
>  
>
Carl will reply to this.

>
>  
>
>> static int
>> rtas_ibm_cbe_perftools(int subfunc, int passthru,
>> 		       void *address, unsigned long length)
>> {
>> 	u64 paddr = __pa(address);
>> 
>>-	return rtas_call(pm_rtas_token, 5, 1, NULL, subfunc, passthru,
>>-			 paddr >> 32, paddr & 0xffffffff, length);
>>+	pm_rtas_token = rtas_token("ibm,cbe-perftools");
>>+
>>+	if (unlikely(pm_rtas_token == RTAS_UNKNOWN_SERVICE)) {
>>+		printk(KERN_ERR
>>+		       "%s: rtas token ibm,cbe-perftools unknown\n",
>>+		       __FUNCTION__);
>>+		return -EFWCALL;
>>+	} else {
>>+
>>+		return rtas_call(pm_rtas_token, 5, 1, NULL, subfunc, 
>>+			 passthru, paddr >> 32, paddr & 0xffffffff, length); 
>>+	}
>> }
>>    
>>
>
>Are you now reading the rtas token every time you call rtas? that seems
>like a waste of time.
>  
>
Carl will reply.

>
>  
>
>>+#define size 24
>>+#define ENTRIES  (0x1<<8) /* 256 */
>>+#define MAXLFSR  0xFFFFFF
>>+
>>+int initial_lfsr[] =
>>+{16777215, 3797240, 13519805, 11602690, 6497030, 7614675, 2328937, 2889445,
>>+ 12364575, 8723156, 2450594, 16280864, 14742496, 10904589, 6434212, 4996256,
>>+ 5814270, 13014041, 9825245, 410260, 904096, 15151047, 15487695, 3061843,
>>+ 16482682, 7938572, 4893279, 9390321, 4320879, 5686402, 1711063, 10176714,
>>+ 4512270, 1057359, 16700434, 5731602, 2070114, 16030890, 1208230, 15603106,
>>+ 11857845, 6470172, 1362790, 7316876, 8534496, 1629197, 10003072, 1714539,
>>+ 1814669, 7106700, 5427154, 3395151, 3683327, 12950450, 16620273, 12122372,
>>+ 7194999, 9952750, 3608260, 13604295, 2266835, 14943567, 7079230, 777380,
>>+ 4516801, 1737661, 8730333, 13796927, 3247181, 9950017, 3481896, 16527555,
>>+ 13116123, 14505033, 9781119, 4860212, 7403253, 13264219, 12269980, 100120,
>>+ 664506, 607795, 8274553, 13133688, 6215305, 13208866, 16439693, 3320753,
>>+ 8773582, 13874619, 1784784, 4513501, 11002978, 9318515, 3038856, 14254582,
>>+ 15484958, 15967857, 13504461, 13657322, 14724513, 13955736, 5695315, 7330509,
>>+ 12630101, 6826854, 439712, 4609055, 13288878, 1309632, 4996398, 11392266,
>>+ 793740, 7653789, 2472670, 14641200, 5164364, 5482529, 10415855, 1629108,
>>+ 2012376, 13661123, 14655718, 9534083, 16637925, 2537745, 9787923, 12750103,
>>+ 4660370, 3283461, 14862772, 7034955, 6679872, 8918232, 6506913, 103649,
>>+ 6085577, 13324033, 14251613, 11058220, 11998181, 3100233, 468898, 7104918,
>>+ 12498413, 14408165, 1208514, 15712321, 3088687, 14778333, 3632503, 11151952,
>>+ 98896, 9159367, 8866146, 4780737, 4925758, 12362320, 4122783, 8543358,
>>+ 7056879, 10876914, 6282881, 1686625, 5100373, 4573666, 9265515, 13593840,
>>+ 5853060, 1188880, 4237111, 15765555, 14344137, 4608332, 6590210, 13745050,
>>+ 10916568, 12340402, 7145275, 4417153, 2300360, 12079643, 7608534, 15238251,
>>+ 4947424, 7014722, 3984546, 7168073, 10759589, 16293080, 3757181, 4577717,
>>+ 5163790, 2488841, 4650617, 3650022, 5440654, 1814617, 6939232, 15540909,
>>+ 501788, 1060986, 5058235, 5078222, 3734500, 10762065, 390862, 5172712,
>>+ 1070780, 7904429, 1669757, 3439997, 2956788, 14944927, 12496638, 994152,
>>+ 8901173, 11827497, 4268056, 15725859, 1694506, 5451950, 2892428, 1434298,
>>+ 9048323, 13558747, 15083840, 8154495, 15830901, 391127, 14970070, 2451434,
>>+ 2080347, 10775644, 14599429, 12540753, 4813943, 16140655, 2421772, 12724304,
>>+ 12935733, 7206473, 5697333, 10328104, 2418008, 13547986, 284246, 1732363,
>>+ 16375319, 8109554, 16372365, 14346072, 1835890, 13059499, 2442500, 4110674};
>>+
>>+/*
>>+ * The hardware uses an LFSR counting sequence to determine when to capture
>>+ * the SPU PCs.  The SPU PC capture is done when the LFSR sequence reaches the
>>+ * last value in the sequence.  An LFSR sequence is like a puesdo random
>>+ * number sequence where each number occurs once in the sequence but the
>>+ * sequence is not in numerical order.  To reduce the calculation time, a
>>+ * sequence of 256 precomputed values in the LFSR sequence are stored in a
>>+ * table.  The nearest precomputed value is used as the initial point from
>>+ * which to caculate the desired LFSR value that is n from the end of the
>>+ * sequence.  The lookup table reduces the maximum number of iterations in
>>+ * the loop from 2^24 to 2^16.
>>+ */
>>+static int calculate_lfsr(int n)
>>+{
>>+  int i;
>>+
>>+  int start_lfsr_index;
>>+  unsigned int newlfsr0;
>>+  unsigned int lfsr = MAXLFSR;
>>+  unsigned int binsize = (MAXLFSR+1)/ENTRIES;
>>+  unsigned int howmany;
>>+
>>+  start_lfsr_index = (MAXLFSR - n) / binsize;
>>+  lfsr = initial_lfsr[start_lfsr_index];
>>+  howmany = (MAXLFSR - n) - (start_lfsr_index * (binsize));
>>+
>>+  for (i = 2; i < howmany+2; i++) {
>>+    newlfsr0 = (((lfsr >> (size - 1 - 0)) & 1) ^
>>+		((lfsr >> (size - 1 - 1)) & 1) ^
>>+		(((lfsr >> (size - 1 - 6)) & 1) ^
>>+		 ((lfsr >> (size - 1 - 23)) & 1)));
>>+
>>+    lfsr >>= 1;
>>+    lfsr = lfsr | (newlfsr0 << (size - 1));
>>+  }
>>+  return lfsr;
>>+}
>>    
>>
>
>I agree with Milton that it would be far nicer even to calculate
>the value from user space, but since you say that would
>violate the oprofile interface conventions, let's not go there.
>In order to make this code nicer on the user, you should probably
>insert a 'cond_resched()' somewhere in the loop, maybe every
>500 iterations or so.
>
>it also looks like there is whitespace damage in the code here.
>  
>
Carl will reply.

>  
>
>>+
>>+/* This interface allows a profiler (e.g., OProfile) to store
>>+ * spu_context information needed for profiling, allowing it to
>>+ * be saved across context save/restore operation.
>>+ *
>>+ * Assumes the caller has already incremented the ref count to
>>+ * profile_info; then spu_context_destroy must call kref_put
>>+ * on prof_info_kref.
>>+ */
>>+void spu_set_profile_private(struct spu_context * ctx, void * profile_info,
>>+			     struct kref * prof_info_kref,
>>+			     void (* prof_info_release) (struct kref * kref))
>>+{
>>+	ctx->profile_private = profile_info;
>>+	ctx->prof_priv_kref = prof_info_kref;
>>+	ctx->prof_priv_release = prof_info_release;
>>+}
>>+EXPORT_SYMBOL_GPL(spu_set_profile_private);
>>    
>>
>
>I think you don't need the profile_private member here, if you just use
>container_of with ctx->prof_priv_kref in all users.
>  
>
Sorry, I don't follow. We want the profile_private to be stored in the 
spu_context, don't we?  How else would I be able to do that?  And 
besides, wouldn't container_of need the struct name of profile_private?  
SPUFS doesn't have access to the type.

-Maynard

>	Arnd <><
>
>-------------------------------------------------------------------------
>Take Surveys. Earn Cash. Influence the Future of IT
>Join SourceForge.net's Techsay panel and you'll get the chance to share your
>opinions on IT & business topics through brief surveys-and earn cash
>http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
>_______________________________________________
>oprofile-list mailing list
>oprofile-list@lists.sourceforge.net
>https://lists.sourceforge.net/lists/listinfo/oprofile-list
>  
>



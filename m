Return-Path: <linux-kernel-owner+w=401wt.eu-S932894AbZGPRhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbZGPRhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932520AbZGPRhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:37:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40557 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868AbZGPRhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:37:05 -0400
Message-ID: <4A5F6571.3020002@redhat.com>
Date: Thu, 16 Jul 2009 13:37:53 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       Przemys??awPawe??czyk <przemyslaw@pawelczyk.it>
Subject: Re: [PATCH -tip -v12 02/11] x86: x86 instruction decoder	build-time
 selftest
References: <20090716155652.6266.39970.stgit@localhost.localdomain> <20090716155706.6266.79022.stgit@localhost.localdomain> <20090716162947.GA5804@merkur.ravnborg.org>
In-Reply-To: <20090716162947.GA5804@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Thu, Jul 16, 2009 at 11:57:06AM -0400, Masami Hiramatsu wrote:
>> Add a user-space selftest of x86 instruction decoder at kernel build time.
>> When CONFIG_X86_DECODER_SELFTEST=y, Kbuild builds a test harness of x86
>> instruction decoder and performs it after building vmlinux.
>> The test compares the results of objdump and x86 instruction decoder
>> code and check there are no differences.
> 
> Long overdue review from my side...
> 
>>  arch/x86/scripts/Makefile       |   19 +++++++
>>  arch/x86/scripts/distill.awk    |   42 +++++++++++++++++
>>  arch/x86/scripts/test_get_len.c |   99 +++++++++++++++++++++++++++++++++++++++
>>  arch/x86/scripts/user_include.h |   49 +++++++++++++++++++
> 
> Hmmm, we have two architectures that uses scripts/ and three that
> uses tools/.
> I prefer the latter name as what we have ere is beyound what
> I generally recognize as a script.
> 
> we have scripts/ in top-level and we do not rename this
> as we have this hardcoded too many places - but no reason to
> use the wrong name here.
> 
>> diff --git a/arch/x86/include/asm/inat.h b/arch/x86/include/asm/inat.h
>> index 01e079a..9090665 100644
>> --- a/arch/x86/include/asm/inat.h
>> +++ b/arch/x86/include/asm/inat.h
>> @@ -20,7 +20,9 @@
>>   * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
>>   *
>>   */
>> +#ifdef __KERNEL__
>>  #include <linux/types.h>
>> +#endif
>>  
>>  /* Instruction attributes */
>>  typedef u32 insn_attr_t;
> 
> Why this?
> If you need this to use this file from userspace then could we do some
> other trick to make this OK?



> 
> I see it repeated several times below.
> [If this has already been discussed I have missed it - sorry].
> 
> 
>> diff --git a/arch/x86/scripts/Makefile b/arch/x86/scripts/Makefile
>> new file mode 100644
>> index 0000000..f08859e
>> --- /dev/null
>> +++ b/arch/x86/scripts/Makefile
>> @@ -0,0 +1,19 @@
>> +PHONY += posttest
>> +quiet_cmd_posttest = TEST    $@
>> +      cmd_posttest = objdump -d $(objtree)/vmlinux | awk -f $(srctree)/arch/x86/scripts/distill.awk | $(obj)/test_get_len
>> +
> 
> You are using the native objdump here.
> But I assume this fails miserably when you build x86 on a powerpc host.
> In other words - you broke an allyesconfig build for -next...
> We have $(OBJDUMP) for this.

Ah, I see... Would you know actual name of x86-objdump on the powerpc
(or any other crosscompiling host)? I just set "OBJDUMP=objdump" is OK?
I'm not so sure about cross-compiling kernel...

>> +posttest: $(obj)/test_get_len vmlinux
>> +	$(call cmd,posttest)
>> +
>> +test_get_len_SRC = $(srctree)/arch/x86/scripts/test_get_len.c $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c
>> +test_get_len_INC = $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
>> +
>> +quiet_cmd_test_get_len = CC      $@
>> +      cmd_test_get_len = $(CC) -Wall $(test_get_len_SRC) -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include -include $(srctree)/arch/x86/scripts/user_include.h -o $@
> 
> Is there a specific reason why you cannot use the standard hostprogs-y for this?
> It will take care of dependency tracking etc.
> What you have above is a hopeless incomplete list of dependencies.
> 
> You need to use HOST_EXTRACFLAGS to set additional -I options and the -include.

Thank you, I'll try to use hostprogs-y.

>> +
>> +static void usage()
>> +{
>> +	fprintf(stderr, "usage: %s < distilled_disassembly\n", prog);
>> +	exit(1);
>> +}
> 
> It would be nice to tell the user what the program is supposed to do.
> I know this is a bit unusual but no reason to copy bad practice.
> 

Sure, maybe copying usage line in distill.awk is more helpful for user...

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


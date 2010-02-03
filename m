Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab0BCRIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:08:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62034 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab0BCRIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:08:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/6] improve sys_personality for compat architectures
Date: Wed, 3 Feb 2010 18:06:27 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc8-00053-g43eb7c4-dirty; KDE/4.3.2; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, tony.luck@intel.com, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, davem@davemloft.net, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, viro@zeniv.linux.org.uk
References: <20100201185607.GD11045@lst.de> <201002021536.51928.arnd@arndb.de> <20100202163145.GA30659@lst.de>
In-Reply-To: <20100202163145.GA30659@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002031806.27423.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19/g8XgiVVUPqbJi1qiz71so4A46hHebnW//l0
 4KWDztmfbg9nejI4AFUx6uSDoYMU0i3+P7CQM1VN26ty0dL2lB
 mEIJvvDETOg5cT+ujywcg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 February 2010 17:31:45 Christoph Hellwig wrote:
> 
> On Tue, Feb 02, 2010 at 03:36:51PM +0100, Arnd Bergmann wrote:
> > > -       return (long)old;
> > > +       return (long)(old == PER_LINUX32 ? PER_LINUX : old);
> > >  }
> > 
> > What does this do for a native 64 bit process setting PER_LINUX32?
> > It looks to me like it could never set it back to the original
> > value, or am I missing something here?
> > 
> > It's what the arch specific code does already, but it seems a bit
> > strange anyway.
> 
> Indeed, this prevents a process from going back to 64bit.  And while
> the setarch tool in util-linux also allows going back to 64-bit the
> typical use case seems to be going into 32-bit mode.

It appears that setarch can only go back into 64 bit mode on x86
because that does not wire up sys32_personality at all -- it always
uses the regular sys_personality, which allows going both ways.

Your patch changes the behavior on x86 to also make the change
to PER_LINUX32 permanent, which seems consistent but possibly not
what people want. I still wonder if anything other than setarch
actually calls personality() to set PER_LINUX32 and what the
real intention of sys32_personality is. From what I can tell here,
it may be best to kill the special handling of PER_LINUX32 entirely
and make everyone use the existing sys_personality.

> But if the consensus is that we should fix this properly I can
> replace the patch with one introducing a compat_sys_personality
> which only gets used for compat tasks.

Right now, sparc64 and powerpc64 use sys32_personality for both native
and compat tasks, x86 never uses it and all others use it only for
compat tasks. That seems more sensible if we keep this function at
all.

	Arnd

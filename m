Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbZJNTN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbZJNTN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbZJNTN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:13:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbZJNTN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:13:26 -0400
Date: Wed, 14 Oct 2009 16:12:56 -0300
From: Glauber Costa <glommer@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] v4: allow userspace to adjust kvmclock offset
Message-ID: <20091014191256.GE8092@mothafucka.localdomain>
References: <1255531666-16090-1-git-send-email-glommer@redhat.com> <20091014185327.GD4218@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014185327.GD4218@amt.cnet>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 03:53:27PM -0300, Marcelo Tosatti wrote:
> On Wed, Oct 14, 2009 at 10:47:46AM -0400, Glauber Costa wrote:
> > When we migrate a kvm guest that uses pvclock between two hosts, we may
> > suffer a large skew. This is because there can be significant differences
> > between the monotonic clock of the hosts involved. When a new host with
> > a much larger monotonic time starts running the guest, the view of time
> > will be significantly impacted.
> > 
> > Situation is much worse when we do the opposite, and migrate to a host with
> > a smaller monotonic clock.
> > 
> > This proposed ioctl will allow userspace to inform us what is the monotonic
> > clock value in the source host, so we can keep the time skew short, and
> > more importantly, never goes backwards. Userspace may also need to trigger
> > the current data, since from the first migration onwards, it won't be
> > reflected by a simple call to clock_gettime() anymore.
> > 
> > [ v2: uses a struct with a padding ]
> > [ v3: provide an ioctl to get clock data too ]
> > [ v4: used fixed-width signed type for delta ]
> > 
> > Signed-off-by: Glauber Costa <glommer@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |    1 +
> >  arch/x86/kvm/x86.c              |   35 ++++++++++++++++++++++++++++++++++-
> >  include/linux/kvm.h             |    7 +++++++
> >  3 files changed, 42 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 179a919..c9b0d9f 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -410,6 +410,7 @@ struct kvm_arch{
> >  
> >  	unsigned long irq_sources_bitmap;
> >  	u64 vm_init_tsc;
> > +	s64 kvmclock_offset;
> >  };
> >  
> >  struct kvm_vm_stat {
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 9601bc6..09f31e2 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -699,7 +699,8 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
> >  	/* With all the info we got, fill in the values */
> >  
> >  	vcpu->hv_clock.system_time = ts.tv_nsec +
> > -				     (NSEC_PER_SEC * (u64)ts.tv_sec);
> > +				     (NSEC_PER_SEC * (u64)ts.tv_sec) + v->kvm->arch.kvmclock_offset;
> > +
> >  	/*
> >  	 * The interface expects us to write an even number signaling that the
> >  	 * update is finished. Since the guest won't see the intermediate
> > @@ -2441,6 +2442,38 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >  		r = 0;
> >  		break;
> >  	}
> > +	case KVM_SET_CLOCK: {
> > +		struct timespec now;
> > +		struct kvm_clock_data user_ns;
> > +		u64 now_ns;
> > +		s64 delta;
> > +
> > +		r =  -EFAULT;
> 
> Extra space :)
want me to send a new because of that?

> 
> >  #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
> >  #define KVM_SET_BOOT_CPU_ID        _IO(KVMIO, 0x78)
> >  #define KVM_IOEVENTFD             _IOW(KVMIO, 0x79, struct kvm_ioeventfd)
> > +#define KVM_SET_CLOCK		  _IOW(KVMIO, 0x7a, struct kvm_clock_data)
> > +#define KVM_GET_CLOCK		  _IOW(KVMIO, 0x7b, struct kvm_clock_data)
> 					  _IOR
> 
> Otherwise looks fine, please send the userspace changes together.
Note that this changed quite a while in the process already. It only makes sense to implement
userspace once this is commited, IMHO.

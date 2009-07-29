Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbZG2NpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbZG2NpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbZG2NpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:45:10 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:19026
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755542AbZG2NpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:45:06 -0400
X-SpamScore: -17
X-BigFish: VPS-17(z34a4jz1432R98dN179dNzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNJQ6W-02-2E6-02
X-M-MSG: 
Date: Wed, 29 Jul 2009 15:44:03 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] kvm/svm: add helper functions for global
 interrupt flag
Message-ID: <20090729134403.GI18313@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
 <1248872192-30881-3-git-send-email-joerg.roedel@amd.com>
 <4A704B5F.5000206@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4A704B5F.5000206@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_Land?=
	=?iso-8859-1?Q?kreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Jul 2009 13:44:03.0724 (UTC) FILETIME=[A2BE8CC0:01CA1052]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 03:15:11PM +0200, Alexander Graf wrote:
> Joerg Roedel wrote:
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kvm/svm.c |   31 +++++++++++++++++++++++--------
> >  1 files changed, 23 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 27d26c3..9f69b25 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -136,6 +136,21 @@ static inline bool is_nested(struct vcpu_svm *svm)
> >  	return svm->nested_vmcb;
> >  }
> >  
> > +static inline void enable_gif(struct vcpu_svm *svm)
> > +{
> > +	svm->vcpu.arch.hflags |= HF_GIF_MASK;
> > +}
> > +
> > +static inline void disable_gif(struct vcpu_svm *svm)
> > +{
> > +	svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
> > +}
> > +
> > +static inline bool gif_set(struct vcpu_svm *svm)
> > +{
> > +	return !!(svm->vcpu.arch.hflags & HF_GIF_MASK);
> > +}
> > +
> >  static unsigned long iopm_base;
> >  
> >  struct kvm_ldttss_desc {
> > @@ -630,7 +645,7 @@ static void init_vmcb(struct vcpu_svm *svm)
> >  	force_new_asid(&svm->vcpu);
> >  
> >  	svm->nested_vmcb = 0;
> > -	svm->vcpu.arch.hflags = HF_GIF_MASK;
> > +	enable_gif(svm);
> >   
> 
> Are we sure hflags is always 0 here?

Hmm, yes. Except for the vcpu reset path clear_page is called for before
init_vmcb is called. I'll change it to set hflags to 0 in this function.

	Joerg



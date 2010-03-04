Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab0CDGJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 01:09:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:32673 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab0CDGJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 01:09:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,579,1262592000"; 
   d="scan'208";a="250674766"
Date: Thu, 4 Mar 2010 14:09:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Wei Ni <wni@nvidia.com>
Cc: Takashi Iwai <tiwai@suse.de>, "'akpm'" <akpm@linux-foundation.org>,
       "'alsa-devel'" <alsa-devel@alsa-project.org>,
       "'linux-kernel'" <linux-kernel@vger.kernel.org>,
       "'Pavel Hofman'" <pavel.hofman@insite.cz>
Subject: Re: [alsa-devel]  [PATCH]Support MCP89 and GT21x hdmi audio
Message-ID: <20100304060913.GA1300@localhost>
References: <6B4D417B830BC44B8026029FD256F7F1C068B2BA8B@HKMAIL01.nvidia.com> <20100302054307.GA6165@localhost> <s5h8wa9oqbi.wl%tiwai@suse.de> <20100304021839.GA13450@localhost> <20100304054410.GA30604@localhost> <6B4D417B830BC44B8026029FD256F7F1C16B1AD551@HKMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6B4D417B830BC44B8026029FD256F7F1C16B1AD551@HKMAIL01.nvidia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh.. I expected these to be standard for HDMI.

On Thu, Mar 04, 2010 at 01:52:40PM +0800, Wei Ni wrote:
> Hi, Wu Fengguang
> These changes only for Nvidia controller.
> 1. for hdmi_channel_mapping[0x2[8]
> Because our controller's channel_mapping has some different with
> patch_intelhdmi.c. If don't change, the 8ch has some wrong.

Maybe I got it wrong. Do you have Intel hardware (G45 or IbexPeak) at
hand?  I cannot test it for now.

> 2. for remove "u8 reserved[5]"
> Because our controller doesn't support it yet.

Have you tried reduce the number to 4 or 3?

> 3. for hdmi_checksum_audio_infoframe()
> Because our controller only support the checkum=0 now.

In fact I'm not absolutely sure if the checksum field
- should be leave 0 and filled by hardware
- or should not exist at all and handled transparently by hardware

Thanks,
Fengguang

> 
> -----Original Message-----
> From: Wu Fengguang [mailto:fengguang.wu@intel.com]
> Sent: Thursday, March 04, 2010 1:44 PM
> To: Takashi Iwai
> Cc: Wei Ni; 'akpm'; 'alsa-devel'; 'linux-kernel'; 'Pavel Hofman'
> Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
> 
> On Thu, Mar 04, 2010 at 10:18:39AM +0800, Wu Fengguang wrote:
> > On Wed, Mar 03, 2010 at 02:46:25PM +0800, Takashi Iwai wrote:
> > > At Tue, 2 Mar 2010 13:43:07 +0800,
> > > Wu Fengguang wrote:
> > > >
> > > > On Mon, Mar 01, 2010 at 07:27:53PM +0800, Wei Ni wrote:
> > > > > Hi, Takashi
> > > > > I developed the hdmi audio driver for new chipset MCP89 and GT21x.
> > > > > The new HAD controller and codec support standard HDMI operation.
> > > > >
> > > > > I attached the patch file, please check it.
> > > >
> > > > Wei Ni,
> > > >
> > > > Can we avoid the big copy&paste and do more code reuse?
> > > > This benefits all of us in long term.
> > >
> > > The plan is to merge all current patch_*hdmi.c into one.
> > > But this can be done later once after we get the working driver
> > > for the new Nvidia codecs.
> > >
> > > The new Nvidia HDMI codec is a bit tricky (which has 4 separate
> > > codec slots), so I'd like to get it working first.
> >
> > Here is the patch to merge common code in a simple way.
> > This is compile tested only, need double check.
> >
> > What puzzled me is that Wei Ni reused the same dynamic parsing code,
> > even though the Intel/Nvidia codecs have vastly different pin/cvt
> > layouts..
> 
> WeiNi, some more questions.
> 
> - why change hdmi_channel_mapping[0x32][8] from
>         [0x13] = { 0x00, 0x11, 0x26, 0x37, 0x43, 0x52, 0x64, 0x75 },
>   to
>         [0x13] = { 0x00, 0x11, 0x32, 0x23, 0x64, 0x75, 0x46, 0x57 },
> 
> - why remove "u8 reserved[5]; /* PB6 - PB10 */" from struct
>   hdmi_audio_infoframe?
> 
> - why change
>         static void hdmi_checksum_audio_infoframe(struct hdmi_audio_infoframe *ai)
>         {
>                 u8 *bytes = (u8 *)ai;
>                 u8 sum = 0;
>                 int i;
> 
>                 ai->checksum = 0;
> 
>                 for (i = 0; i < sizeof(*ai); i++)
>                         sum += bytes[i];
> 
>                 ai->checksum = - sum;
>         }
>   to
>         static void hdmi_checksum_audio_infoframe(struct hdmi_audio_infoframe *ai)
>         {
>                 ai->checksum = 0;
>         }
> 
> 
> Those are very dirty changes. Either the original code is correct, or
> they are wrong and should be changed as well. If you submit code like
> this now, we'll have to resolve conflicts and do pointless retests at
> the perceived future merge time.
> 
> Would you stop hacking things around like that?
> 
> I'd recommend to base your future work on top of the following patch.
> It's based on your previous patches.
> 
> Note that I reverted the above 3 changes. If they are good changes,
> you can still submit standalone patches, and let's discuss and test
> them case by case.
> 
> Thanks,
> Fengguang
> ---
> hdmi - create patch_hdmi.c for common hdmi code
> 
> For now the patch_hdmi.c file is simply included by patch_intelhdmi.c
> and patch_nvhdmi.c, and does not represent a real codec.
> 
> CC: Wei Ni <wni@nvidia.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  sound/pci/hda/patch_hdmi.c      |  828 ++++++++++++++++++++++++++++++
>  sound/pci/hda/patch_intelhdmi.c |  822 -----------------------------
>  sound/pci/hda/patch_nvhdmi.c    |  817 -----------------------------
>  3 files changed, 856 insertions(+), 1611 deletions(-)
> 
> --- sound-2.6.orig/sound/pci/hda/patch_intelhdmi.c      2010-03-04 13:14:54.000000000 +0800
> +++ sound-2.6/sound/pci/hda/patch_intelhdmi.c   2010-03-04 13:14:56.000000000 +0800
> @@ -33,822 +33,20 @@
>  #include "hda_codec.h"
>  #include "hda_local.h"
> 
> -/*
> - * The HDMI/DisplayPort configuration can be highly dynamic. A graphics device
> - * could support two independent pipes, each of them can be connected to one or
> - * more ports (DVI, HDMI or DisplayPort).
> - *
> - * The HDA correspondence of pipes/ports are converter/pin nodes.
> - */
> +#include "patch_hdmi.c"
> +
>  #define INTEL_HDMI_CVTS        2
>  #define INTEL_HDMI_PINS        3
> 
> -static char *intel_hdmi_pcm_names[INTEL_HDMI_CVTS] = {
> +static char *intel_hdmi_pcm_names[MAX_HDMI_CVTS] = {
>         "INTEL HDMI 0",
>         "INTEL HDMI 1",
>  };
> 
> -struct intel_hdmi_spec {
> -       int num_cvts;
> -       int num_pins;
> -       hda_nid_t cvt[INTEL_HDMI_CVTS+1];  /* audio sources */
> -       hda_nid_t pin[INTEL_HDMI_PINS+1];  /* audio sinks */
> -
> -       /*
> -        * source connection for each pin
> -        */
> -       hda_nid_t pin_cvt[INTEL_HDMI_PINS+1];
> -
> -       /*
> -        * HDMI sink attached to each pin
> -        */
> -       struct hdmi_eld sink_eld[INTEL_HDMI_PINS];
> -
> -       /*
> -        * export one pcm per pipe
> -        */
> -       struct hda_pcm  pcm_rec[INTEL_HDMI_CVTS];
> -};
> -
> -struct hdmi_audio_infoframe {
> -       u8 type; /* 0x84 */
> -       u8 ver;  /* 0x01 */
> -       u8 len;  /* 0x0a */
> -
> -       u8 checksum;    /* PB0 */
> -       u8 CC02_CT47;   /* CC in bits 0:2, CT in 4:7 */
> -       u8 SS01_SF24;
> -       u8 CXT04;
> -       u8 CA;
> -       u8 LFEPBL01_LSV36_DM_INH7;
> -       u8 reserved[5]; /* PB6 - PB10 */
> -};
> -
> -/*
> - * CEA speaker placement:
> - *
> - *        FLH       FCH        FRH
> - *  FLW    FL  FLC   FC   FRC   FR   FRW
> - *
> - *                                  LFE
> - *                     TC
> - *
> - *          RL  RLC   RC   RRC   RR
> - *
> - * The Left/Right Surround channel _notions_ LS/RS in SMPTE 320M corresponds to
> - * CEA RL/RR; The SMPTE channel _assignment_ C/LFE is swapped to CEA LFE/FC.
> - */
> -enum cea_speaker_placement {
> -       FL  = (1 <<  0),        /* Front Left           */
> -       FC  = (1 <<  1),        /* Front Center         */
> -       FR  = (1 <<  2),        /* Front Right          */
> -       FLC = (1 <<  3),        /* Front Left Center    */
> -       FRC = (1 <<  4),        /* Front Right Center   */
> -       RL  = (1 <<  5),        /* Rear Left            */
> -       RC  = (1 <<  6),        /* Rear Center          */
> -       RR  = (1 <<  7),        /* Rear Right           */
> -       RLC = (1 <<  8),        /* Rear Left Center     */
> -       RRC = (1 <<  9),        /* Rear Right Center    */
> -       LFE = (1 << 10),        /* Low Frequency Effect */
> -       FLW = (1 << 11),        /* Front Left Wide      */
> -       FRW = (1 << 12),        /* Front Right Wide     */
> -       FLH = (1 << 13),        /* Front Left High      */
> -       FCH = (1 << 14),        /* Front Center High    */
> -       FRH = (1 << 15),        /* Front Right High     */
> -       TC  = (1 << 16),        /* Top Center           */
> -};
> -
> -/*
> - * ELD SA bits in the CEA Speaker Allocation data block
> - */
> -static int eld_speaker_allocation_bits[] = {
> -       [0] = FL | FR,
> -       [1] = LFE,
> -       [2] = FC,
> -       [3] = RL | RR,
> -       [4] = RC,
> -       [5] = FLC | FRC,
> -       [6] = RLC | RRC,
> -       /* the following are not defined in ELD yet */
> -       [7] = FLW | FRW,
> -       [8] = FLH | FRH,
> -       [9] = TC,
> -       [10] = FCH,
> -};
> -
> -struct cea_channel_speaker_allocation {
> -       int ca_index;
> -       int speakers[8];
> -
> -       /* derived values, just for convenience */
> -       int channels;
> -       int spk_mask;
> -};
> -
> -/*
> - * ALSA sequence is:
> - *
> - *       surround40   surround41   surround50   surround51   surround71
> - * ch0   front left   =            =            =            =
> - * ch1   front right  =            =            =            =
> - * ch2   rear left    =            =            =            =
> - * ch3   rear right   =            =            =            =
> - * ch4                LFE          center       center       center
> - * ch5                                          LFE          LFE
> - * ch6                                                       side left
> - * ch7                                                       side right
> - *
> - * surround71 = {FL, FR, RLC, RRC, FC, LFE, RL, RR}
> - */
> -static int hdmi_channel_mapping[0x32][8] = {
> -       /* stereo */
> -       [0x00] = { 0x00, 0x11, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7 },
> -       /* 2.1 */
> -       [0x01] = { 0x00, 0x11, 0x22, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7 },
> -       /* Dolby Surround */
> -       [0x02] = { 0x00, 0x11, 0x23, 0xf2, 0xf4, 0xf5, 0xf6, 0xf7 },
> -       /* surround40 */
> -       [0x08] = { 0x00, 0x11, 0x24, 0x35, 0xf3, 0xf2, 0xf6, 0xf7 },
> -       /* 4ch */
> -       [0x03] = { 0x00, 0x11, 0x23, 0x32, 0x44, 0xf5, 0xf6, 0xf7 },
> -       /* surround41 */
> -       [0x09] = { 0x00, 0x11, 0x24, 0x34, 0x43, 0xf2, 0xf6, 0xf7 },
> -       /* surround50 */
> -       [0x0a] = { 0x00, 0x11, 0x24, 0x35, 0x43, 0xf2, 0xf6, 0xf7 },
> -       /* surround51 */
> -       [0x0b] = { 0x00, 0x11, 0x24, 0x35, 0x43, 0x52, 0xf6, 0xf7 },
> -       /* 7.1 */
> -       [0x13] = { 0x00, 0x11, 0x26, 0x37, 0x43, 0x52, 0x64, 0x75 },
> -};
> -
> -/*
> - * This is an ordered list!
> - *
> - * The preceding ones have better chances to be selected by
> - * hdmi_setup_channel_allocation().
> - */
> -static struct cea_channel_speaker_allocation channel_allocations[] = {
> -/*                       channel:   7     6    5    4    3     2    1    0  */
> -{ .ca_index = 0x00,  .speakers = {   0,    0,   0,   0,   0,    0,  FR,  FL } },
> -                                /* 2.1 */
> -{ .ca_index = 0x01,  .speakers = {   0,    0,   0,   0,   0,  LFE,  FR,  FL } },
> -                                /* Dolby Surround */
> -{ .ca_index = 0x02,  .speakers = {   0,    0,   0,   0,  FC,    0,  FR,  FL } },
> -                                /* surround40 */
> -{ .ca_index = 0x08,  .speakers = {   0,    0,  RR,  RL,   0,    0,  FR,  FL } },
> -                                /* surround41 */
> -{ .ca_index = 0x09,  .speakers = {   0,    0,  RR,  RL,   0,  LFE,  FR,  FL } },
> -                                /* surround50 */
> -{ .ca_index = 0x0a,  .speakers = {   0,    0,  RR,  RL,  FC,    0,  FR,  FL } },
> -                                /* surround51 */
> -{ .ca_index = 0x0b,  .speakers = {   0,    0,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -                                /* 6.1 */
> -{ .ca_index = 0x0f,  .speakers = {   0,   RC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -                                /* surround71 */
> -{ .ca_index = 0x13,  .speakers = { RRC,  RLC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -
> -{ .ca_index = 0x03,  .speakers = {   0,    0,   0,   0,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x04,  .speakers = {   0,    0,   0,  RC,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x05,  .speakers = {   0,    0,   0,  RC,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x06,  .speakers = {   0,    0,   0,  RC,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x07,  .speakers = {   0,    0,   0,  RC,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x0c,  .speakers = {   0,   RC,  RR,  RL,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x0d,  .speakers = {   0,   RC,  RR,  RL,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x0e,  .speakers = {   0,   RC,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x10,  .speakers = { RRC,  RLC,  RR,  RL,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x11,  .speakers = { RRC,  RLC,  RR,  RL,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x12,  .speakers = { RRC,  RLC,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x14,  .speakers = { FRC,  FLC,   0,   0,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x15,  .speakers = { FRC,  FLC,   0,   0,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x16,  .speakers = { FRC,  FLC,   0,   0,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x17,  .speakers = { FRC,  FLC,   0,   0,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x18,  .speakers = { FRC,  FLC,   0,  RC,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x19,  .speakers = { FRC,  FLC,   0,  RC,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x1a,  .speakers = { FRC,  FLC,   0,  RC,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x1b,  .speakers = { FRC,  FLC,   0,  RC,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x1c,  .speakers = { FRC,  FLC,  RR,  RL,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x1d,  .speakers = { FRC,  FLC,  RR,  RL,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x1e,  .speakers = { FRC,  FLC,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x1f,  .speakers = { FRC,  FLC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x20,  .speakers = {   0,  FCH,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x21,  .speakers = {   0,  FCH,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x22,  .speakers = {  TC,    0,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x23,  .speakers = {  TC,    0,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x24,  .speakers = { FRH,  FLH,  RR,  RL,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x25,  .speakers = { FRH,  FLH,  RR,  RL,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x26,  .speakers = { FRW,  FLW,  RR,  RL,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x27,  .speakers = { FRW,  FLW,  RR,  RL,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x28,  .speakers = {  TC,   RC,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x29,  .speakers = {  TC,   RC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x2a,  .speakers = { FCH,   RC,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x2b,  .speakers = { FCH,   RC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x2c,  .speakers = {  TC,  FCH,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x2d,  .speakers = {  TC,  FCH,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x2e,  .speakers = { FRH,  FLH,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x2f,  .speakers = { FRH,  FLH,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x30,  .speakers = { FRW,  FLW,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x31,  .speakers = { FRW,  FLW,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -};
> -
> -/*
> - * HDA/HDMI auto parsing
> - */
> -
> -static int hda_node_index(hda_nid_t *nids, hda_nid_t nid)
> -{
> -       int i;
> -
> -       for (i = 0; nids[i]; i++)
> -               if (nids[i] == nid)
> -                       return i;
> -
> -       snd_printk(KERN_WARNING "HDMI: nid %d not registered\n", nid);
> -       return -EINVAL;
> -}
> -
> -static int intel_hdmi_read_pin_conn(struct hda_codec *codec, hda_nid_t pin_nid)
> -{
> -       struct intel_hdmi_spec *spec = codec->spec;
> -       hda_nid_t conn_list[HDA_MAX_CONNECTIONS];
> -       int conn_len, curr;
> -       int index;
> -
> -       if (!(get_wcaps(codec, pin_nid) & AC_WCAP_CONN_LIST)) {
> -               snd_printk(KERN_WARNING
> -                          "HDMI: pin %d wcaps %#x "
> -                          "does not support connection list\n",
> -                          pin_nid, get_wcaps(codec, pin_nid));
> -               return -EINVAL;
> -       }
> -
> -       conn_len = snd_hda_get_connections(codec, pin_nid, conn_list,
> -                                          HDA_MAX_CONNECTIONS);
> -       if (conn_len > 1)
> -               curr = snd_hda_codec_read(codec, pin_nid, 0,
> -                                         AC_VERB_GET_CONNECT_SEL, 0);
> -       else
> -               curr = 0;
> -
> -       index = hda_node_index(spec->pin, pin_nid);
> -       if (index < 0)
> -               return -EINVAL;
> -
> -       spec->pin_cvt[index] = conn_list[curr];
> -
> -       return 0;
> -}
> -
> -static void hdmi_get_show_eld(struct hda_codec *codec, hda_nid_t pin_nid,
> -                             struct hdmi_eld *eld)
> -{
> -       if (!snd_hdmi_get_eld(eld, codec, pin_nid))
> -               snd_hdmi_show_eld(eld);
> -}
> -
> -static void hdmi_present_sense(struct hda_codec *codec, hda_nid_t pin_nid,
> -                              struct hdmi_eld *eld)
> -{
> -       int present = snd_hda_pin_sense(codec, pin_nid);
> -
> -       eld->monitor_present    = !!(present & AC_PINSENSE_PRESENCE);
> -       eld->eld_valid          = !!(present & AC_PINSENSE_ELDV);
> -
> -       if (present & AC_PINSENSE_ELDV)
> -               hdmi_get_show_eld(codec, pin_nid, eld);
> -}
> -
> -static int intel_hdmi_add_pin(struct hda_codec *codec, hda_nid_t pin_nid)
> -{
> -       struct intel_hdmi_spec *spec = codec->spec;
> -
> -       if (spec->num_pins >= INTEL_HDMI_PINS) {
> -               snd_printk(KERN_WARNING
> -                          "HDMI: no space for pin %d \n", pin_nid);
> -               return -EINVAL;
> -       }
> -
> -       hdmi_present_sense(codec, pin_nid, &spec->sink_eld[spec->num_pins]);
> -
> -       spec->pin[spec->num_pins] = pin_nid;
> -       spec->num_pins++;
> -
> -       /*
> -        * It is assumed that converter nodes come first in the node list and
> -        * hence have been registered and usable now.
> -        */
> -       return intel_hdmi_read_pin_conn(codec, pin_nid);
> -}
> -
> -static int intel_hdmi_add_cvt(struct hda_codec *codec, hda_nid_t nid)
> -{
> -       struct intel_hdmi_spec *spec = codec->spec;
> -
> -       if (spec->num_cvts >= INTEL_HDMI_CVTS) {
> -               snd_printk(KERN_WARNING
> -                          "HDMI: no space for converter %d \n", nid);
> -               return -EINVAL;
> -       }
> -
> -       spec->cvt[spec->num_cvts] = nid;
> -       spec->num_cvts++;
> -
> -       return 0;
> -}
> -
> -static int intel_hdmi_parse_codec(struct hda_codec *codec)
> -{
> -       hda_nid_t nid;
> -       int i, nodes;
> -
> -       nodes = snd_hda_get_sub_nodes(codec, codec->afg, &nid);
> -       if (!nid || nodes < 0) {
> -               snd_printk(KERN_WARNING "HDMI: failed to get afg sub nodes\n");
> -               return -EINVAL;
> -       }
> -
> -       for (i = 0; i < nodes; i++, nid++) {
> -               unsigned int caps;
> -               unsigned int type;
> -
> -               caps = snd_hda_param_read(codec, nid, AC_PAR_AUDIO_WIDGET_CAP);
> -               type = get_wcaps_type(caps);
> -
> -               if (!(caps & AC_WCAP_DIGITAL))
> -                       continue;
> -
> -               switch (type) {
> -               case AC_WID_AUD_OUT:
> -                       if (intel_hdmi_add_cvt(codec, nid) < 0)
> -                               return -EINVAL;
> -                       break;
> -               case AC_WID_PIN:
> -                       caps = snd_hda_param_read(codec, nid, AC_PAR_PIN_CAP);
> -                       if (!(caps & (AC_PINCAP_HDMI | AC_PINCAP_DP)))
> -                               continue;
> -                       if (intel_hdmi_add_pin(codec, nid) < 0)
> -                               return -EINVAL;
> -                       break;
> -               }
> -       }
> -
> -       /*
> -        * G45/IbexPeak don't support EPSS: the unsolicited pin hot plug event
> -        * can be lost and presence sense verb will become inaccurate if the
> -        * HDA link is powered off at hot plug or hw initialization time.
> -        */
> -#ifdef CONFIG_SND_HDA_POWER_SAVE
> -       if (!(snd_hda_param_read(codec, codec->afg, AC_PAR_POWER_STATE) &
> -             AC_PWRST_EPSS))
> -               codec->bus->power_keep_link_on = 1;
> -#endif
> -
> -       return 0;
> -}
> -
>  /*
>   * HDMI routines
>   */
> 
> -#ifdef BE_PARANOID
> -static void hdmi_get_dip_index(struct hda_codec *codec, hda_nid_t pin_nid,
> -                               int *packet_index, int *byte_index)
> -{
> -       int val;
> -
> -       val = snd_hda_codec_read(codec, pin_nid, 0,
> -                                AC_VERB_GET_HDMI_DIP_INDEX, 0);
> -
> -       *packet_index = val >> 5;
> -       *byte_index = val & 0x1f;
> -}
> -#endif
> -
> -static void hdmi_set_dip_index(struct hda_codec *codec, hda_nid_t pin_nid,
> -                               int packet_index, int byte_index)
> -{
> -       int val;
> -
> -       val = (packet_index << 5) | (byte_index & 0x1f);
> -
> -       snd_hda_codec_write(codec, pin_nid, 0, AC_VERB_SET_HDMI_DIP_INDEX, val);
> -}
> -
> -static void hdmi_write_dip_byte(struct hda_codec *codec, hda_nid_t pin_nid,
> -                               unsigned char val)
> -{
> -       snd_hda_codec_write(codec, pin_nid, 0, AC_VERB_SET_HDMI_DIP_DATA, val);
> -}
> -
> -static void hdmi_enable_output(struct hda_codec *codec, hda_nid_t pin_nid)
> -{
> -       /* Unmute */
> -       if (get_wcaps(codec, pin_nid) & AC_WCAP_OUT_AMP)
> -               snd_hda_codec_write(codec, pin_nid, 0,
> -                               AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
> -       /* Enable pin out */
> -       snd_hda_codec_write(codec, pin_nid, 0,
> -                           AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
> -}
> -
> -/*
> - * Enable Audio InfoFrame Transmission
> - */
> -static void hdmi_start_infoframe_trans(struct hda_codec *codec,
> -                                      hda_nid_t pin_nid)
> -{
> -       hdmi_set_dip_index(codec, pin_nid, 0x0, 0x0);
> -       snd_hda_codec_write(codec, pin_nid, 0, AC_VERB_SET_HDMI_DIP_XMIT,
> -                                               AC_DIPXMIT_BEST);
> -}
> -
> -/*
> - * Disable Audio InfoFrame Transmission
> - */
> -static void hdmi_stop_infoframe_trans(struct hda_codec *codec,
> -                                     hda_nid_t pin_nid)
> -{
> -       hdmi_set_dip_index(codec, pin_nid, 0x0, 0x0);
> -       snd_hda_codec_write(codec, pin_nid, 0, AC_VERB_SET_HDMI_DIP_XMIT,
> -                                               AC_DIPXMIT_DISABLE);
> -}
> -
> -static int hdmi_get_channel_count(struct hda_codec *codec, hda_nid_t nid)
> -{
> -       return 1 + snd_hda_codec_read(codec, nid, 0,
> -                                       AC_VERB_GET_CVT_CHAN_COUNT, 0);
> -}
> -
> -static void hdmi_set_channel_count(struct hda_codec *codec,
> -                                  hda_nid_t nid, int chs)
> -{
> -       if (chs != hdmi_get_channel_count(codec, nid))
> -               snd_hda_codec_write(codec, nid, 0,
> -                                   AC_VERB_SET_CVT_CHAN_COUNT, chs - 1);
> -}
> -
> -static void hdmi_debug_channel_mapping(struct hda_codec *codec,
> -                                      hda_nid_t pin_nid)
> -{
> -#ifdef CONFIG_SND_DEBUG_VERBOSE
> -       int i;
> -       int slot;
> -
> -       for (i = 0; i < 8; i++) {
> -               slot = snd_hda_codec_read(codec, pin_nid, 0,
> -                                               AC_VERB_GET_HDMI_CHAN_SLOT, i);
> -               printk(KERN_DEBUG "HDMI: ASP channel %d => slot %d\n",
> -                                               slot >> 4, slot & 0xf);
> -       }
> -#endif
> -}
> -
> -
> -/*
> - * Audio InfoFrame routines
> - */
> -
> -static void hdmi_debug_dip_size(struct hda_codec *codec, hda_nid_t pin_nid)
> -{
> -#ifdef CONFIG_SND_DEBUG_VERBOSE
> -       int i;
> -       int size;
> -
> -       size = snd_hdmi_get_eld_size(codec, pin_nid);
> -       printk(KERN_DEBUG "HDMI: ELD buf size is %d\n", size);
> -
> -       for (i = 0; i < 8; i++) {
> -               size = snd_hda_codec_read(codec, pin_nid, 0,
> -                                               AC_VERB_GET_HDMI_DIP_SIZE, i);
> -               printk(KERN_DEBUG "HDMI: DIP GP[%d] buf size is %d\n", i, size);
> -       }
> -#endif
> -}
> -
> -static void hdmi_clear_dip_buffers(struct hda_codec *codec, hda_nid_t pin_nid)
> -{
> -#ifdef BE_PARANOID
> -       int i, j;
> -       int size;
> -       int pi, bi;
> -       for (i = 0; i < 8; i++) {
> -               size = snd_hda_codec_read(codec, pin_nid, 0,
> -                                               AC_VERB_GET_HDMI_DIP_SIZE, i);
> -               if (size == 0)
> -                       continue;
> -
> -               hdmi_set_dip_index(codec, pin_nid, i, 0x0);
> -               for (j = 1; j < 1000; j++) {
> -                       hdmi_write_dip_byte(codec, pin_nid, 0x0);
> -                       hdmi_get_dip_index(codec, pin_nid, &pi, &bi);
> -                       if (pi != i)
> -                               snd_printd(KERN_INFO "dip index %d: %d != %d\n",
> -                                               bi, pi, i);
> -                       if (bi == 0) /* byte index wrapped around */
> -                               break;
> -               }
> -               snd_printd(KERN_INFO
> -                       "HDMI: DIP GP[%d] buf reported size=%d, written=%d\n",
> -                       i, size, j);
> -       }
> -#endif
> -}
> -
> -static void hdmi_checksum_audio_infoframe(struct hdmi_audio_infoframe *ai)
> -{
> -       u8 *bytes = (u8 *)ai;
> -       u8 sum = 0;
> -       int i;
> -
> -       ai->checksum = 0;
> -
> -       for (i = 0; i < sizeof(*ai); i++)
> -               sum += bytes[i];
> -
> -       ai->checksum = - sum;
> -}
> -
> -static void hdmi_fill_audio_infoframe(struct hda_codec *codec,
> -                                     hda_nid_t pin_nid,
> -                                     struct hdmi_audio_infoframe *ai)
> -{
> -       u8 *bytes = (u8 *)ai;
> -       int i;
> -
> -       hdmi_debug_dip_size(codec, pin_nid);
> -       hdmi_clear_dip_buffers(codec, pin_nid); /* be paranoid */
> -
> -       hdmi_checksum_audio_infoframe(ai);
> -
> -       hdmi_set_dip_index(codec, pin_nid, 0x0, 0x0);
> -       for (i = 0; i < sizeof(*ai); i++)
> -               hdmi_write_dip_byte(codec, pin_nid, bytes[i]);
> -}
> -
> -/*
> - * Compute derived values in channel_allocations[].
> - */
> -static void init_channel_allocations(void)
> -{
> -       int i, j;
> -       struct cea_channel_speaker_allocation *p;
> -
> -       for (i = 0; i < ARRAY_SIZE(channel_allocations); i++) {
> -               p = channel_allocations + i;
> -               p->channels = 0;
> -               p->spk_mask = 0;
> -               for (j = 0; j < ARRAY_SIZE(p->speakers); j++)
> -                       if (p->speakers[j]) {
> -                               p->channels++;
> -                               p->spk_mask |= p->speakers[j];
> -                       }
> -       }
> -}
> -
> -/*
> - * The transformation takes two steps:
> - *
> - *     eld->spk_alloc => (eld_speaker_allocation_bits[]) => spk_mask
> - *           spk_mask => (channel_allocations[])         => ai->CA
> - *
> - * TODO: it could select the wrong CA from multiple candidates.
> -*/
> -static int hdmi_setup_channel_allocation(struct hda_codec *codec, hda_nid_t nid,
> -                                        struct hdmi_audio_infoframe *ai)
> -{
> -       struct intel_hdmi_spec *spec = codec->spec;
> -       struct hdmi_eld *eld;
> -       int i;
> -       int spk_mask = 0;
> -       int channels = 1 + (ai->CC02_CT47 & 0x7);
> -       char buf[SND_PRINT_CHANNEL_ALLOCATION_ADVISED_BUFSIZE];
> -
> -       /*
> -        * CA defaults to 0 for basic stereo audio
> -        */
> -       if (channels <= 2)
> -               return 0;
> -
> -       i = hda_node_index(spec->pin_cvt, nid);
> -       if (i < 0)
> -               return 0;
> -       eld = &spec->sink_eld[i];
> -
> -       /*
> -        * HDMI sink's ELD info cannot always be retrieved for now, e.g.
> -        * in console or for audio devices. Assume the highest speakers
> -        * configuration, to _not_ prohibit multi-channel audio playback.
> -        */
> -       if (!eld->spk_alloc)
> -               eld->spk_alloc = 0xffff;
> -
> -       /*
> -        * expand ELD's speaker allocation mask
> -        *
> -        * ELD tells the speaker mask in a compact(paired) form,
> -        * expand ELD's notions to match the ones used by Audio InfoFrame.
> -        */
> -       for (i = 0; i < ARRAY_SIZE(eld_speaker_allocation_bits); i++) {
> -               if (eld->spk_alloc & (1 << i))
> -                       spk_mask |= eld_speaker_allocation_bits[i];
> -       }
> -
> -       /* search for the first working match in the CA table */
> -       for (i = 0; i < ARRAY_SIZE(channel_allocations); i++) {
> -               if (channels == channel_allocations[i].channels &&
> -                   (spk_mask & channel_allocations[i].spk_mask) ==
> -                               channel_allocations[i].spk_mask) {
> -                       ai->CA = channel_allocations[i].ca_index;
> -                       break;
> -               }
> -       }
> -
> -       snd_print_channel_allocation(eld->spk_alloc, buf, sizeof(buf));
> -       snd_printdd(KERN_INFO
> -                       "HDMI: select CA 0x%x for %d-channel allocation: %s\n",
> -                       ai->CA, channels, buf);
> -
> -       return ai->CA;
> -}
> -
> -static void hdmi_setup_channel_mapping(struct hda_codec *codec,
> -                                      hda_nid_t pin_nid,
> -                                      struct hdmi_audio_infoframe *ai)
> -{
> -       int i;
> -       int ca = ai->CA;
> -       int err;
> -
> -       if (hdmi_channel_mapping[ca][1] == 0) {
> -               for (i = 0; i < channel_allocations[ca].channels; i++)
> -                       hdmi_channel_mapping[ca][i] = i | (i << 4);
> -               for (; i < 8; i++)
> -                       hdmi_channel_mapping[ca][i] = 0xf | (i << 4);
> -       }
> -
> -       for (i = 0; i < 8; i++) {
> -               err = snd_hda_codec_write(codec, pin_nid, 0,
> -                                         AC_VERB_SET_HDMI_CHAN_SLOT,
> -                                         hdmi_channel_mapping[ca][i]);
> -               if (err) {
> -                       snd_printdd(KERN_INFO "HDMI: channel mapping failed\n");
> -                       break;
> -               }
> -       }
> -
> -       hdmi_debug_channel_mapping(codec, pin_nid);
> -}
> -
> -static bool hdmi_infoframe_uptodate(struct hda_codec *codec, hda_nid_t pin_nid,
> -                                   struct hdmi_audio_infoframe *ai)
> -{
> -       u8 *bytes = (u8 *)ai;
> -       u8 val;
> -       int i;
> -
> -       if (snd_hda_codec_read(codec, pin_nid, 0, AC_VERB_GET_HDMI_DIP_XMIT, 0)
> -                                                           != AC_DIPXMIT_BEST)
> -               return false;
> -
> -       hdmi_set_dip_index(codec, pin_nid, 0x0, 0x0);
> -       for (i = 0; i < sizeof(*ai); i++) {
> -               val = snd_hda_codec_read(codec, pin_nid, 0,
> -                                        AC_VERB_GET_HDMI_DIP_DATA, 0);
> -               if (val != bytes[i])
> -                       return false;
> -       }
> -
> -       return true;
> -}
> -
> -static void hdmi_setup_audio_infoframe(struct hda_codec *codec, hda_nid_t nid,
> -                                       struct snd_pcm_substream *substream)
> -{
> -       struct intel_hdmi_spec *spec = codec->spec;
> -       hda_nid_t pin_nid;
> -       int i;
> -       struct hdmi_audio_infoframe ai = {
> -               .type           = 0x84,
> -               .ver            = 0x01,
> -               .len            = 0x0a,
> -               .CC02_CT47      = substream->runtime->channels - 1,
> -       };
> -
> -       hdmi_setup_channel_allocation(codec, nid, &ai);
> -
> -       for (i = 0; i < spec->num_pins; i++) {
> -               if (spec->pin_cvt[i] != nid)
> -                       continue;
> -               if (!spec->sink_eld[i].monitor_present)
> -                       continue;
> -
> -               pin_nid = spec->pin[i];
> -               if (!hdmi_infoframe_uptodate(codec, pin_nid, &ai)) {
> -                       hdmi_setup_channel_mapping(codec, pin_nid, &ai);
> -                       hdmi_stop_infoframe_trans(codec, pin_nid);
> -                       hdmi_fill_audio_infoframe(codec, pin_nid, &ai);
> -                       hdmi_start_infoframe_trans(codec, pin_nid);
> -               }
> -       }
> -}
> -
> -
> -/*
> - * Unsolicited events
> - */
> -
> -static void hdmi_intrinsic_event(struct hda_codec *codec, unsigned int res)
> -{
> -       struct intel_hdmi_spec *spec = codec->spec;
> -       int tag = res >> AC_UNSOL_RES_TAG_SHIFT;
> -       int pind = !!(res & AC_UNSOL_RES_PD);
> -       int eldv = !!(res & AC_UNSOL_RES_ELDV);
> -       int index;
> -
> -       printk(KERN_INFO
> -               "HDMI hot plug event: Pin=%d Presence_Detect=%d ELD_Valid=%d\n",
> -               tag, pind, eldv);
> -
> -       index = hda_node_index(spec->pin, tag);
> -       if (index < 0)
> -               return;
> -
> -       spec->sink_eld[index].monitor_present = pind;
> -       spec->sink_eld[index].eld_valid = eldv;
> -
> -       if (pind && eldv) {
> -               hdmi_get_show_eld(codec, spec->pin[index], &spec->sink_eld[index]);
> -               /* TODO: do real things about ELD */
> -       }
> -}
> -
> -static void hdmi_non_intrinsic_event(struct hda_codec *codec, unsigned int res)
> -{
> -       int tag = res >> AC_UNSOL_RES_TAG_SHIFT;
> -       int subtag = (res & AC_UNSOL_RES_SUBTAG) >> AC_UNSOL_RES_SUBTAG_SHIFT;
> -       int cp_state = !!(res & AC_UNSOL_RES_CP_STATE);
> -       int cp_ready = !!(res & AC_UNSOL_RES_CP_READY);
> -
> -       printk(KERN_INFO
> -               "HDMI CP event: PIN=%d SUBTAG=0x%x CP_STATE=%d CP_READY=%d\n",
> -               tag,
> -               subtag,
> -               cp_state,
> -               cp_ready);
> -
> -       /* TODO */
> -       if (cp_state)
> -               ;
> -       if (cp_ready)
> -               ;
> -}
> -
> -
> -static void intel_hdmi_unsol_event(struct hda_codec *codec, unsigned int res)
> -{
> -       struct intel_hdmi_spec *spec = codec->spec;
> -       int tag = res >> AC_UNSOL_RES_TAG_SHIFT;
> -       int subtag = (res & AC_UNSOL_RES_SUBTAG) >> AC_UNSOL_RES_SUBTAG_SHIFT;
> -
> -       if (hda_node_index(spec->pin, tag) < 0) {
> -               snd_printd(KERN_INFO "Unexpected HDMI event tag 0x%x\n", tag);
> -               return;
> -       }
> -
> -       if (subtag == 0)
> -               hdmi_intrinsic_event(codec, res);
> -       else
> -               hdmi_non_intrinsic_event(codec, res);
> -}
> -
> -/*
> - * Callbacks
> - */
> -
> -static void hdmi_setup_stream(struct hda_codec *codec, hda_nid_t nid,
> -                             u32 stream_tag, int format)
> -{
> -       int tag;
> -       int fmt;
> -
> -       tag = snd_hda_codec_read(codec, nid, 0, AC_VERB_GET_CONV, 0) >> 4;
> -       fmt = snd_hda_codec_read(codec, nid, 0, AC_VERB_GET_STREAM_FORMAT, 0);
> -
> -       snd_printdd("hdmi_setup_stream: "
> -                   "NID=0x%x, %sstream=0x%x, %sformat=0x%x\n",
> -                   nid,
> -                   tag == stream_tag ? "" : "new-",
> -                   stream_tag,
> -                   fmt == format ? "" : "new-",
> -                   format);
> -
> -       if (tag != stream_tag)
> -               snd_hda_codec_write(codec, nid, 0,
> -                                   AC_VERB_SET_CHANNEL_STREAMID, stream_tag << 4);
> -       if (fmt != format)
> -               snd_hda_codec_write(codec, nid, 0,
> -                                   AC_VERB_SET_STREAM_FORMAT, format);
> -}
> -
>  static int intel_hdmi_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
>                                            struct hda_codec *codec,
>                                            unsigned int stream_tag,
> @@ -882,7 +80,7 @@ static struct hda_pcm_stream intel_hdmi_
> 
>  static int intel_hdmi_build_pcms(struct hda_codec *codec)
>  {
> -       struct intel_hdmi_spec *spec = codec->spec;
> +       struct hdmi_spec *spec = codec->spec;
>         struct hda_pcm *info = spec->pcm_rec;
>         int i;
> 
> @@ -908,7 +106,7 @@ static int intel_hdmi_build_pcms(struct
> 
>  static int intel_hdmi_build_controls(struct hda_codec *codec)
>  {
> -       struct intel_hdmi_spec *spec = codec->spec;
> +       struct hdmi_spec *spec = codec->spec;
>         int err;
>         int i;
> 
> @@ -923,7 +121,7 @@ static int intel_hdmi_build_controls(str
> 
>  static int intel_hdmi_init(struct hda_codec *codec)
>  {
> -       struct intel_hdmi_spec *spec = codec->spec;
> +       struct hdmi_spec *spec = codec->spec;
>         int i;
> 
>         for (i = 0; spec->pin[i]; i++) {
> @@ -937,7 +135,7 @@ static int intel_hdmi_init(struct hda_co
> 
>  static void intel_hdmi_free(struct hda_codec *codec)
>  {
> -       struct intel_hdmi_spec *spec = codec->spec;
> +       struct hdmi_spec *spec = codec->spec;
>         int i;
> 
>         for (i = 0; i < spec->num_pins; i++)
> @@ -951,12 +149,12 @@ static struct hda_codec_ops intel_hdmi_p
>         .free                   = intel_hdmi_free,
>         .build_pcms             = intel_hdmi_build_pcms,
>         .build_controls         = intel_hdmi_build_controls,
> -       .unsol_event            = intel_hdmi_unsol_event,
> +       .unsol_event            = hdmi_unsol_event,
>  };
> 
>  static int patch_intel_hdmi(struct hda_codec *codec)
>  {
> -       struct intel_hdmi_spec *spec;
> +       struct hdmi_spec *spec;
>         int i;
> 
>         spec = kzalloc(sizeof(*spec), GFP_KERNEL);
> @@ -964,7 +162,7 @@ static int patch_intel_hdmi(struct hda_c
>                 return -ENOMEM;
> 
>         codec->spec = spec;
> -       if (intel_hdmi_parse_codec(codec) < 0) {
> +       if (hdmi_parse_codec(codec) < 0) {
>                 codec->spec = NULL;
>                 kfree(spec);
>                 return -EINVAL;
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ sound-2.6/sound/pci/hda/patch_hdmi.c        2010-03-04 13:30:14.000000000 +0800
> @@ -0,0 +1,828 @@
> +/*
> + * The HDMI/DisplayPort configuration can be highly dynamic. A graphics device
> + * could support two independent pipes, each of them can be connected to one or
> + * more ports (DVI, HDMI or DisplayPort).
> + *
> + * The HDA correspondence of pipes/ports are converter/pin nodes.
> + */
> +#define MAX_HDMI_CVTS  2
> +#define MAX_HDMI_PINS  3
> +
> +
> +struct hdmi_spec {
> +       int num_cvts;
> +       int num_pins;
> +       hda_nid_t cvt[MAX_HDMI_CVTS+1];  /* audio sources */
> +       hda_nid_t pin[MAX_HDMI_PINS+1];  /* audio sinks */
> +
> +       /*
> +        * source connection for each pin
> +        */
> +       hda_nid_t pin_cvt[MAX_HDMI_PINS+1];
> +
> +       /*
> +        * HDMI sink attached to each pin
> +        */
> +       struct hdmi_eld sink_eld[MAX_HDMI_PINS];
> +
> +       /*
> +        * export one pcm per pipe
> +        */
> +       struct hda_pcm  pcm_rec[MAX_HDMI_CVTS];
> +
> +       /*
> +        * nvhdmi specific
> +        */
> +       struct hda_multi_out multiout;
> +       unsigned int codec_type;
> +};
> +
> +
> +struct hdmi_audio_infoframe {
> +       u8 type; /* 0x84 */
> +       u8 ver;  /* 0x01 */
> +       u8 len;  /* 0x0a */
> +
> +       u8 checksum;    /* PB0 */
> +       u8 CC02_CT47;   /* CC in bits 0:2, CT in 4:7 */
> +       u8 SS01_SF24;
> +       u8 CXT04;
> +       u8 CA;
> +       u8 LFEPBL01_LSV36_DM_INH7;
> +       u8 reserved[5]; /* PB6 - PB10 */
> +};
> +
> +/*
> + * CEA speaker placement:
> + *
> + *        FLH       FCH        FRH
> + *  FLW    FL  FLC   FC   FRC   FR   FRW
> + *
> + *                                  LFE
> + *                     TC
> + *
> + *          RL  RLC   RC   RRC   RR
> + *
> + * The Left/Right Surround channel _notions_ LS/RS in SMPTE 320M corresponds to
> + * CEA RL/RR; The SMPTE channel _assignment_ C/LFE is swapped to CEA LFE/FC.
> + */
> +enum cea_speaker_placement {
> +       FL  = (1 <<  0),        /* Front Left           */
> +       FC  = (1 <<  1),        /* Front Center         */
> +       FR  = (1 <<  2),        /* Front Right          */
> +       FLC = (1 <<  3),        /* Front Left Center    */
> +       FRC = (1 <<  4),        /* Front Right Center   */
> +       RL  = (1 <<  5),        /* Rear Left            */
> +       RC  = (1 <<  6),        /* Rear Center          */
> +       RR  = (1 <<  7),        /* Rear Right           */
> +       RLC = (1 <<  8),        /* Rear Left Center     */
> +       RRC = (1 <<  9),        /* Rear Right Center    */
> +       LFE = (1 << 10),        /* Low Frequency Effect */
> +       FLW = (1 << 11),        /* Front Left Wide      */
> +       FRW = (1 << 12),        /* Front Right Wide     */
> +       FLH = (1 << 13),        /* Front Left High      */
> +       FCH = (1 << 14),        /* Front Center High    */
> +       FRH = (1 << 15),        /* Front Right High     */
> +       TC  = (1 << 16),        /* Top Center           */
> +};
> +
> +/*
> + * ELD SA bits in the CEA Speaker Allocation data block
> + */
> +static int eld_speaker_allocation_bits[] = {
> +       [0] = FL | FR,
> +       [1] = LFE,
> +       [2] = FC,
> +       [3] = RL | RR,
> +       [4] = RC,
> +       [5] = FLC | FRC,
> +       [6] = RLC | RRC,
> +       /* the following are not defined in ELD yet */
> +       [7] = FLW | FRW,
> +       [8] = FLH | FRH,
> +       [9] = TC,
> +       [10] = FCH,
> +};
> +
> +struct cea_channel_speaker_allocation {
> +       int ca_index;
> +       int speakers[8];
> +
> +       /* derived values, just for convenience */
> +       int channels;
> +       int spk_mask;
> +};
> +
> +/*
> + * ALSA sequence is:
> + *
> + *       surround40   surround41   surround50   surround51   surround71
> + * ch0   front left   =            =            =            =
> + * ch1   front right  =            =            =            =
> + * ch2   rear left    =            =            =            =
> + * ch3   rear right   =            =            =            =
> + * ch4                LFE          center       center       center
> + * ch5                                          LFE          LFE
> + * ch6                                                       side left
> + * ch7                                                       side right
> + *
> + * surround71 = {FL, FR, RLC, RRC, FC, LFE, RL, RR}
> + */
> +static int hdmi_channel_mapping[0x32][8] = {
> +       /* stereo */
> +       [0x00] = { 0x00, 0x11, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7 },
> +       /* 2.1 */
> +       [0x01] = { 0x00, 0x11, 0x22, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7 },
> +       /* Dolby Surround */
> +       [0x02] = { 0x00, 0x11, 0x23, 0xf2, 0xf4, 0xf5, 0xf6, 0xf7 },
> +       /* surround40 */
> +       [0x08] = { 0x00, 0x11, 0x24, 0x35, 0xf3, 0xf2, 0xf6, 0xf7 },
> +       /* 4ch */
> +       [0x03] = { 0x00, 0x11, 0x23, 0x32, 0x44, 0xf5, 0xf6, 0xf7 },
> +       /* surround41 */
> +       [0x09] = { 0x00, 0x11, 0x24, 0x34, 0x43, 0xf2, 0xf6, 0xf7 },
> +       /* surround50 */
> +       [0x0a] = { 0x00, 0x11, 0x24, 0x35, 0x43, 0xf2, 0xf6, 0xf7 },
> +       /* surround51 */
> +       [0x0b] = { 0x00, 0x11, 0x24, 0x35, 0x43, 0x52, 0xf6, 0xf7 },
> +       /* 7.1 */
> +       [0x13] = { 0x00, 0x11, 0x26, 0x37, 0x43, 0x52, 0x64, 0x75 },
> +};
> +
> +/*
> + * This is an ordered list!
> + *
> + * The preceding ones have better chances to be selected by
> + * hdmi_setup_channel_allocation().
> + */
> +static struct cea_channel_speaker_allocation channel_allocations[] = {
> +/*                       channel:   7     6    5    4    3     2    1    0  */
> +{ .ca_index = 0x00,  .speakers = {   0,    0,   0,   0,   0,    0,  FR,  FL } },
> +                                /* 2.1 */
> +{ .ca_index = 0x01,  .speakers = {   0,    0,   0,   0,   0,  LFE,  FR,  FL } },
> +                                /* Dolby Surround */
> +{ .ca_index = 0x02,  .speakers = {   0,    0,   0,   0,  FC,    0,  FR,  FL } },
> +                                /* surround40 */
> +{ .ca_index = 0x08,  .speakers = {   0,    0,  RR,  RL,   0,    0,  FR,  FL } },
> +                                /* surround41 */
> +{ .ca_index = 0x09,  .speakers = {   0,    0,  RR,  RL,   0,  LFE,  FR,  FL } },
> +                                /* surround50 */
> +{ .ca_index = 0x0a,  .speakers = {   0,    0,  RR,  RL,  FC,    0,  FR,  FL } },
> +                                /* surround51 */
> +{ .ca_index = 0x0b,  .speakers = {   0,    0,  RR,  RL,  FC,  LFE,  FR,  FL } },
> +                                /* 6.1 */
> +{ .ca_index = 0x0f,  .speakers = {   0,   RC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> +                                /* surround71 */
> +{ .ca_index = 0x13,  .speakers = { RRC,  RLC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> +
> +{ .ca_index = 0x03,  .speakers = {   0,    0,   0,   0,  FC,  LFE,  FR,  FL } },
> +{ .ca_index = 0x04,  .speakers = {   0,    0,   0,  RC,   0,    0,  FR,  FL } },
> +{ .ca_index = 0x05,  .speakers = {   0,    0,   0,  RC,   0,  LFE,  FR,  FL } },
> +{ .ca_index = 0x06,  .speakers = {   0,    0,   0,  RC,  FC,    0,  FR,  FL } },
> +{ .ca_index = 0x07,  .speakers = {   0,    0,   0,  RC,  FC,  LFE,  FR,  FL } },
> +{ .ca_index = 0x0c,  .speakers = {   0,   RC,  RR,  RL,   0,    0,  FR,  FL } },
> +{ .ca_index = 0x0d,  .speakers = {   0,   RC,  RR,  RL,   0,  LFE,  FR,  FL } },
> +{ .ca_index = 0x0e,  .speakers = {   0,   RC,  RR,  RL,  FC,    0,  FR,  FL } },
> +{ .ca_index = 0x10,  .speakers = { RRC,  RLC,  RR,  RL,   0,    0,  FR,  FL } },
> +{ .ca_index = 0x11,  .speakers = { RRC,  RLC,  RR,  RL,   0,  LFE,  FR,  FL } },
> +{ .ca_index = 0x12,  .speakers = { RRC,  RLC,  RR,  RL,  FC,    0,  FR,  FL } },
> +{ .ca_index = 0x14,  .speakers = { FRC,  FLC,   0,   0,   0,    0,  FR,  FL } },
> +{ .ca_index = 0x15,  .speakers = { FRC,  FLC,   0,   0,   0,  LFE,  FR,  FL } },
> +{ .ca_index = 0x16,  .speakers = { FRC,  FLC,   0,   0,  FC,    0,  FR,  FL } },
> +{ .ca_index = 0x17,  .speakers = { FRC,  FLC,   0,   0,  FC,  LFE,  FR,  FL } },
> +{ .ca_index = 0x18,  .speakers = { FRC,  FLC,   0,  RC,   0,    0,  FR,  FL } },
> +{ .ca_index = 0x19,  .speakers = { FRC,  FLC,   0,  RC,   0,  LFE,  FR,  FL } },
> +{ .ca_index = 0x1a,  .speakers = { FRC,  FLC,   0,  RC,  FC,    0,  FR,  FL } },
> +{ .ca_index = 0x1b,  .speakers = { FRC,  FLC,   0,  RC,  FC,  LFE,  FR,  FL } },
> +{ .ca_index = 0x1c,  .speakers = { FRC,  FLC,  RR,  RL,   0,    0,  FR,  FL } },
> +{ .ca_index = 0x1d,  .speakers = { FRC,  FLC,  RR,  RL,   0,  LFE,  FR,  FL } },
> +{ .ca_index = 0x1e,  .speakers = { FRC,  FLC,  RR,  RL,  FC,    0,  FR,  FL } },
> +{ .ca_index = 0x1f,  .speakers = { FRC,  FLC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> +{ .ca_index = 0x20,  .speakers = {   0,  FCH,  RR,  RL,  FC,    0,  FR,  FL } },
> +{ .ca_index = 0x21,  .speakers = {   0,  FCH,  RR,  RL,  FC,  LFE,  FR,  FL } },
> +{ .ca_index = 0x22,  .speakers = {  TC,    0,  RR,  RL,  FC,    0,  FR,  FL } },
> +{ .ca_index = 0x23,  .speakers = {  TC,    0,  RR,  RL,  FC,  LFE,  FR,  FL } },
> +{ .ca_index = 0x24,  .speakers = { FRH,  FLH,  RR,  RL,   0,    0,  FR,  FL } },
> +{ .ca_index = 0x25,  .speakers = { FRH,  FLH,  RR,  RL,   0,  LFE,  FR,  FL } },
> +{ .ca_index = 0x26,  .speakers = { FRW,  FLW,  RR,  RL,   0,    0,  FR,  FL } },
> +{ .ca_index = 0x27,  .speakers = { FRW,  FLW,  RR,  RL,   0,  LFE,  FR,  FL } },
> +{ .ca_index = 0x28,  .speakers = {  TC,   RC,  RR,  RL,  FC,    0,  FR,  FL } },
> +{ .ca_index = 0x29,  .speakers = {  TC,   RC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> +{ .ca_index = 0x2a,  .speakers = { FCH,   RC,  RR,  RL,  FC,    0,  FR,  FL } },
> +{ .ca_index = 0x2b,  .speakers = { FCH,   RC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> +{ .ca_index = 0x2c,  .speakers = {  TC,  FCH,  RR,  RL,  FC,    0,  FR,  FL } },
> +{ .ca_index = 0x2d,  .speakers = {  TC,  FCH,  RR,  RL,  FC,  LFE,  FR,  FL } },
> +{ .ca_index = 0x2e,  .speakers = { FRH,  FLH,  RR,  RL,  FC,    0,  FR,  FL } },
> +{ .ca_index = 0x2f,  .speakers = { FRH,  FLH,  RR,  RL,  FC,  LFE,  FR,  FL } },
> +{ .ca_index = 0x30,  .speakers = { FRW,  FLW,  RR,  RL,  FC,    0,  FR,  FL } },
> +{ .ca_index = 0x31,  .speakers = { FRW,  FLW,  RR,  RL,  FC,  LFE,  FR,  FL } },
> +};
> +
> +
> +/*
> + * HDMI routines
> + */
> +
> +static int hda_node_index(hda_nid_t *nids, hda_nid_t nid)
> +{
> +       int i;
> +
> +       for (i = 0; nids[i]; i++)
> +               if (nids[i] == nid)
> +                       return i;
> +
> +       snd_printk(KERN_WARNING "HDMI: nid %d not registered\n", nid);
> +       return -EINVAL;
> +}
> +
> +static void hdmi_get_show_eld(struct hda_codec *codec, hda_nid_t pin_nid,
> +                             struct hdmi_eld *eld)
> +{
> +       if (!snd_hdmi_get_eld(eld, codec, pin_nid))
> +               snd_hdmi_show_eld(eld);
> +}
> +
> +#ifdef BE_PARANOID
> +static void hdmi_get_dip_index(struct hda_codec *codec, hda_nid_t pin_nid,
> +                               int *packet_index, int *byte_index)
> +{
> +       int val;
> +
> +       val = snd_hda_codec_read(codec, pin_nid, 0,
> +                                AC_VERB_GET_HDMI_DIP_INDEX, 0);
> +
> +       *packet_index = val >> 5;
> +       *byte_index = val & 0x1f;
> +}
> +#endif
> +
> +static void hdmi_set_dip_index(struct hda_codec *codec, hda_nid_t pin_nid,
> +                               int packet_index, int byte_index)
> +{
> +       int val;
> +
> +       val = (packet_index << 5) | (byte_index & 0x1f);
> +
> +       snd_hda_codec_write(codec, pin_nid, 0, AC_VERB_SET_HDMI_DIP_INDEX, val);
> +}
> +
> +static void hdmi_write_dip_byte(struct hda_codec *codec, hda_nid_t pin_nid,
> +                               unsigned char val)
> +{
> +       snd_hda_codec_write(codec, pin_nid, 0, AC_VERB_SET_HDMI_DIP_DATA, val);
> +}
> +
> +static void hdmi_enable_output(struct hda_codec *codec, hda_nid_t pin_nid)
> +{
> +       /* Unmute */
> +       if (get_wcaps(codec, pin_nid) & AC_WCAP_OUT_AMP)
> +               snd_hda_codec_write(codec, pin_nid, 0,
> +                               AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
> +       /* Enable pin out */
> +       snd_hda_codec_write(codec, pin_nid, 0,
> +                           AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
> +}
> +
> +static int hdmi_get_channel_count(struct hda_codec *codec, hda_nid_t nid)
> +{
> +       return 1 + snd_hda_codec_read(codec, nid, 0,
> +                                       AC_VERB_GET_CVT_CHAN_COUNT, 0);
> +}
> +
> +static void hdmi_set_channel_count(struct hda_codec *codec,
> +                                  hda_nid_t nid, int chs)
> +{
> +       if (chs != hdmi_get_channel_count(codec, nid))
> +               snd_hda_codec_write(codec, nid, 0,
> +                                   AC_VERB_SET_CVT_CHAN_COUNT, chs - 1);
> +}
> +
> +
> +/*
> + * Channel mapping routines
> + */
> +
> +/*
> + * Compute derived values in channel_allocations[].
> + */
> +static void init_channel_allocations(void)
> +{
> +       int i, j;
> +       struct cea_channel_speaker_allocation *p;
> +
> +       for (i = 0; i < ARRAY_SIZE(channel_allocations); i++) {
> +               p = channel_allocations + i;
> +               p->channels = 0;
> +               p->spk_mask = 0;
> +               for (j = 0; j < ARRAY_SIZE(p->speakers); j++)
> +                       if (p->speakers[j]) {
> +                               p->channels++;
> +                               p->spk_mask |= p->speakers[j];
> +                       }
> +       }
> +}
> +
> +/*
> + * The transformation takes two steps:
> + *
> + *     eld->spk_alloc => (eld_speaker_allocation_bits[]) => spk_mask
> + *           spk_mask => (channel_allocations[])         => ai->CA
> + *
> + * TODO: it could select the wrong CA from multiple candidates.
> +*/
> +static int hdmi_setup_channel_allocation(struct hda_codec *codec, hda_nid_t nid,
> +                                        struct hdmi_audio_infoframe *ai)
> +{
> +       struct hdmi_spec *spec = codec->spec;
> +       struct hdmi_eld *eld;
> +       int i;
> +       int spk_mask = 0;
> +       int channels = 1 + (ai->CC02_CT47 & 0x7);
> +       char buf[SND_PRINT_CHANNEL_ALLOCATION_ADVISED_BUFSIZE];
> +
> +       /*
> +        * CA defaults to 0 for basic stereo audio
> +        */
> +       if (channels <= 2)
> +               return 0;
> +
> +       i = hda_node_index(spec->pin_cvt, nid);
> +       if (i < 0)
> +               return 0;
> +       eld = &spec->sink_eld[i];
> +
> +       /*
> +        * HDMI sink's ELD info cannot always be retrieved for now, e.g.
> +        * in console or for audio devices. Assume the highest speakers
> +        * configuration, to _not_ prohibit multi-channel audio playback.
> +        */
> +       if (!eld->spk_alloc)
> +               eld->spk_alloc = 0xffff;
> +
> +       /*
> +        * expand ELD's speaker allocation mask
> +        *
> +        * ELD tells the speaker mask in a compact(paired) form,
> +        * expand ELD's notions to match the ones used by Audio InfoFrame.
> +        */
> +       for (i = 0; i < ARRAY_SIZE(eld_speaker_allocation_bits); i++) {
> +               if (eld->spk_alloc & (1 << i))
> +                       spk_mask |= eld_speaker_allocation_bits[i];
> +       }
> +
> +       /* search for the first working match in the CA table */
> +       for (i = 0; i < ARRAY_SIZE(channel_allocations); i++) {
> +               if (channels == channel_allocations[i].channels &&
> +                   (spk_mask & channel_allocations[i].spk_mask) ==
> +                               channel_allocations[i].spk_mask) {
> +                       ai->CA = channel_allocations[i].ca_index;
> +                       break;
> +               }
> +       }
> +
> +       snd_print_channel_allocation(eld->spk_alloc, buf, sizeof(buf));
> +       snd_printdd(KERN_INFO
> +                       "HDMI: select CA 0x%x for %d-channel allocation: %s\n",
> +                       ai->CA, channels, buf);
> +
> +       return ai->CA;
> +}
> +
> +static void hdmi_debug_channel_mapping(struct hda_codec *codec,
> +                                      hda_nid_t pin_nid)
> +{
> +#ifdef CONFIG_SND_DEBUG_VERBOSE
> +       int i;
> +       int slot;
> +
> +       for (i = 0; i < 8; i++) {
> +               slot = snd_hda_codec_read(codec, pin_nid, 0,
> +                                               AC_VERB_GET_HDMI_CHAN_SLOT, i);
> +               printk(KERN_DEBUG "HDMI: ASP channel %d => slot %d\n",
> +                                               slot >> 4, slot & 0xf);
> +       }
> +#endif
> +}
> +
> +
> +static void hdmi_setup_channel_mapping(struct hda_codec *codec,
> +                                      hda_nid_t pin_nid,
> +                                      struct hdmi_audio_infoframe *ai)
> +{
> +       int i;
> +       int ca = ai->CA;
> +       int err;
> +
> +       if (hdmi_channel_mapping[ca][1] == 0) {
> +               for (i = 0; i < channel_allocations[ca].channels; i++)
> +                       hdmi_channel_mapping[ca][i] = i | (i << 4);
> +               for (; i < 8; i++)
> +                       hdmi_channel_mapping[ca][i] = 0xf | (i << 4);
> +       }
> +
> +       for (i = 0; i < 8; i++) {
> +               err = snd_hda_codec_write(codec, pin_nid, 0,
> +                                         AC_VERB_SET_HDMI_CHAN_SLOT,
> +                                         hdmi_channel_mapping[ca][i]);
> +               if (err) {
> +                       snd_printdd(KERN_INFO "HDMI: channel mapping failed\n");
> +                       break;
> +               }
> +       }
> +
> +       hdmi_debug_channel_mapping(codec, pin_nid);
> +}
> +
> +
> +/*
> + * Audio InfoFrame routines
> + */
> +
> +/*
> + * Enable Audio InfoFrame Transmission
> + */
> +static void hdmi_start_infoframe_trans(struct hda_codec *codec,
> +                                      hda_nid_t pin_nid)
> +{
> +       hdmi_set_dip_index(codec, pin_nid, 0x0, 0x0);
> +       snd_hda_codec_write(codec, pin_nid, 0, AC_VERB_SET_HDMI_DIP_XMIT,
> +                                               AC_DIPXMIT_BEST);
> +}
> +
> +/*
> + * Disable Audio InfoFrame Transmission
> + */
> +static void hdmi_stop_infoframe_trans(struct hda_codec *codec,
> +                                     hda_nid_t pin_nid)
> +{
> +       hdmi_set_dip_index(codec, pin_nid, 0x0, 0x0);
> +       snd_hda_codec_write(codec, pin_nid, 0, AC_VERB_SET_HDMI_DIP_XMIT,
> +                                               AC_DIPXMIT_DISABLE);
> +}
> +
> +static void hdmi_debug_dip_size(struct hda_codec *codec, hda_nid_t pin_nid)
> +{
> +#ifdef CONFIG_SND_DEBUG_VERBOSE
> +       int i;
> +       int size;
> +
> +       size = snd_hdmi_get_eld_size(codec, pin_nid);
> +       printk(KERN_DEBUG "HDMI: ELD buf size is %d\n", size);
> +
> +       for (i = 0; i < 8; i++) {
> +               size = snd_hda_codec_read(codec, pin_nid, 0,
> +                                               AC_VERB_GET_HDMI_DIP_SIZE, i);
> +               printk(KERN_DEBUG "HDMI: DIP GP[%d] buf size is %d\n", i, size);
> +       }
> +#endif
> +}
> +
> +static void hdmi_clear_dip_buffers(struct hda_codec *codec, hda_nid_t pin_nid)
> +{
> +#ifdef BE_PARANOID
> +       int i, j;
> +       int size;
> +       int pi, bi;
> +       for (i = 0; i < 8; i++) {
> +               size = snd_hda_codec_read(codec, pin_nid, 0,
> +                                               AC_VERB_GET_HDMI_DIP_SIZE, i);
> +               if (size == 0)
> +                       continue;
> +
> +               hdmi_set_dip_index(codec, pin_nid, i, 0x0);
> +               for (j = 1; j < 1000; j++) {
> +                       hdmi_write_dip_byte(codec, pin_nid, 0x0);
> +                       hdmi_get_dip_index(codec, pin_nid, &pi, &bi);
> +                       if (pi != i)
> +                               snd_printd(KERN_INFO "dip index %d: %d != %d\n",
> +                                               bi, pi, i);
> +                       if (bi == 0) /* byte index wrapped around */
> +                               break;
> +               }
> +               snd_printd(KERN_INFO
> +                       "HDMI: DIP GP[%d] buf reported size=%d, written=%d\n",
> +                       i, size, j);
> +       }
> +#endif
> +}
> +
> +static void hdmi_checksum_audio_infoframe(struct hdmi_audio_infoframe *ai)
> +{
> +       u8 *bytes = (u8 *)ai;
> +       u8 sum = 0;
> +       int i;
> +
> +       ai->checksum = 0;
> +
> +       for (i = 0; i < sizeof(*ai); i++)
> +               sum += bytes[i];
> +
> +       ai->checksum = - sum;
> +}
> +
> +static void hdmi_fill_audio_infoframe(struct hda_codec *codec,
> +                                     hda_nid_t pin_nid,
> +                                     struct hdmi_audio_infoframe *ai)
> +{
> +       u8 *bytes = (u8 *)ai;
> +       int i;
> +
> +       hdmi_debug_dip_size(codec, pin_nid);
> +       hdmi_clear_dip_buffers(codec, pin_nid); /* be paranoid */
> +
> +       hdmi_checksum_audio_infoframe(ai);
> +
> +       hdmi_set_dip_index(codec, pin_nid, 0x0, 0x0);
> +       for (i = 0; i < sizeof(*ai); i++)
> +               hdmi_write_dip_byte(codec, pin_nid, bytes[i]);
> +}
> +
> +static bool hdmi_infoframe_uptodate(struct hda_codec *codec, hda_nid_t pin_nid,
> +                                   struct hdmi_audio_infoframe *ai)
> +{
> +       u8 *bytes = (u8 *)ai;
> +       u8 val;
> +       int i;
> +
> +       if (snd_hda_codec_read(codec, pin_nid, 0, AC_VERB_GET_HDMI_DIP_XMIT, 0)
> +                                                           != AC_DIPXMIT_BEST)
> +               return false;
> +
> +       hdmi_set_dip_index(codec, pin_nid, 0x0, 0x0);
> +       for (i = 0; i < sizeof(*ai); i++) {
> +               val = snd_hda_codec_read(codec, pin_nid, 0,
> +                                        AC_VERB_GET_HDMI_DIP_DATA, 0);
> +               if (val != bytes[i])
> +                       return false;
> +       }
> +
> +       return true;
> +}
> +
> +static void hdmi_setup_audio_infoframe(struct hda_codec *codec, hda_nid_t nid,
> +                                       struct snd_pcm_substream *substream)
> +{
> +       struct hdmi_spec *spec = codec->spec;
> +       hda_nid_t pin_nid;
> +       int i;
> +       struct hdmi_audio_infoframe ai = {
> +               .type           = 0x84,
> +               .ver            = 0x01,
> +               .len            = 0x0a,
> +               .CC02_CT47      = substream->runtime->channels - 1,
> +       };
> +
> +       hdmi_setup_channel_allocation(codec, nid, &ai);
> +
> +       for (i = 0; i < spec->num_pins; i++) {
> +               if (spec->pin_cvt[i] != nid)
> +                       continue;
> +               if (!spec->sink_eld[i].monitor_present)
> +                       continue;
> +
> +               pin_nid = spec->pin[i];
> +               if (!hdmi_infoframe_uptodate(codec, pin_nid, &ai)) {
> +                       hdmi_setup_channel_mapping(codec, pin_nid, &ai);
> +                       hdmi_stop_infoframe_trans(codec, pin_nid);
> +                       hdmi_fill_audio_infoframe(codec, pin_nid, &ai);
> +                       hdmi_start_infoframe_trans(codec, pin_nid);
> +               }
> +       }
> +}
> +
> +
> +/*
> + * Unsolicited events
> + */
> +
> +static void hdmi_intrinsic_event(struct hda_codec *codec, unsigned int res)
> +{
> +       struct hdmi_spec *spec = codec->spec;
> +       int tag = res >> AC_UNSOL_RES_TAG_SHIFT;
> +       int pind = !!(res & AC_UNSOL_RES_PD);
> +       int eldv = !!(res & AC_UNSOL_RES_ELDV);
> +       int index;
> +
> +       printk(KERN_INFO
> +               "HDMI hot plug event: Pin=%d Presence_Detect=%d ELD_Valid=%d\n",
> +               tag, pind, eldv);
> +
> +       index = hda_node_index(spec->pin, tag);
> +       if (index < 0)
> +               return;
> +
> +       spec->sink_eld[index].monitor_present = pind;
> +       spec->sink_eld[index].eld_valid = eldv;
> +
> +       if (pind && eldv) {
> +               hdmi_get_show_eld(codec, spec->pin[index],
> +                                 &spec->sink_eld[index]);
> +               /* TODO: do real things about ELD */
> +       }
> +}
> +
> +static void hdmi_non_intrinsic_event(struct hda_codec *codec, unsigned int res)
> +{
> +       int tag = res >> AC_UNSOL_RES_TAG_SHIFT;
> +       int subtag = (res & AC_UNSOL_RES_SUBTAG) >> AC_UNSOL_RES_SUBTAG_SHIFT;
> +       int cp_state = !!(res & AC_UNSOL_RES_CP_STATE);
> +       int cp_ready = !!(res & AC_UNSOL_RES_CP_READY);
> +
> +       printk(KERN_INFO
> +               "HDMI CP event: PIN=%d SUBTAG=0x%x CP_STATE=%d CP_READY=%d\n",
> +               tag,
> +               subtag,
> +               cp_state,
> +               cp_ready);
> +
> +       /* TODO */
> +       if (cp_state)
> +               ;
> +       if (cp_ready)
> +               ;
> +}
> +
> +
> +static void hdmi_unsol_event(struct hda_codec *codec, unsigned int res)
> +{
> +       struct hdmi_spec *spec = codec->spec;
> +       int tag = res >> AC_UNSOL_RES_TAG_SHIFT;
> +       int subtag = (res & AC_UNSOL_RES_SUBTAG) >> AC_UNSOL_RES_SUBTAG_SHIFT;
> +
> +       if (hda_node_index(spec->pin, tag) < 0) {
> +               snd_printd(KERN_INFO "Unexpected HDMI event tag 0x%x\n", tag);
> +               return;
> +       }
> +
> +       if (subtag == 0)
> +               hdmi_intrinsic_event(codec, res);
> +       else
> +               hdmi_non_intrinsic_event(codec, res);
> +}
> +
> +/*
> + * Callbacks
> + */
> +
> +static void hdmi_setup_stream(struct hda_codec *codec, hda_nid_t nid,
> +                             u32 stream_tag, int format)
> +{
> +       int tag;
> +       int fmt;
> +
> +       tag = snd_hda_codec_read(codec, nid, 0, AC_VERB_GET_CONV, 0) >> 4;
> +       fmt = snd_hda_codec_read(codec, nid, 0, AC_VERB_GET_STREAM_FORMAT, 0);
> +
> +       snd_printdd("hdmi_setup_stream: "
> +                   "NID=0x%x, %sstream=0x%x, %sformat=0x%x\n",
> +                   nid,
> +                   tag == stream_tag ? "" : "new-",
> +                   stream_tag,
> +                   fmt == format ? "" : "new-",
> +                   format);
> +
> +       if (tag != stream_tag)
> +               snd_hda_codec_write(codec, nid, 0,
> +                                   AC_VERB_SET_CHANNEL_STREAMID,
> +                                   stream_tag << 4);
> +       if (fmt != format)
> +               snd_hda_codec_write(codec, nid, 0,
> +                                   AC_VERB_SET_STREAM_FORMAT, format);
> +}
> +
> +/*
> + * HDA/HDMI auto parsing
> + */
> +
> +static int hdmi_read_pin_conn(struct hda_codec *codec, hda_nid_t pin_nid)
> +{
> +       struct hdmi_spec *spec = codec->spec;
> +       hda_nid_t conn_list[HDA_MAX_CONNECTIONS];
> +       int conn_len, curr;
> +       int index;
> +
> +       if (!(get_wcaps(codec, pin_nid) & AC_WCAP_CONN_LIST)) {
> +               snd_printk(KERN_WARNING
> +                          "HDMI: pin %d wcaps %#x "
> +                          "does not support connection list\n",
> +                          pin_nid, get_wcaps(codec, pin_nid));
> +               return -EINVAL;
> +       }
> +
> +       conn_len = snd_hda_get_connections(codec, pin_nid, conn_list,
> +                                          HDA_MAX_CONNECTIONS);
> +       if (conn_len > 1)
> +               curr = snd_hda_codec_read(codec, pin_nid, 0,
> +                                         AC_VERB_GET_CONNECT_SEL, 0);
> +       else
> +               curr = 0;
> +
> +       index = hda_node_index(spec->pin, pin_nid);
> +       if (index < 0)
> +               return -EINVAL;
> +
> +       spec->pin_cvt[index] = conn_list[curr];
> +
> +       return 0;
> +}
> +
> +static void hdmi_present_sense(struct hda_codec *codec, hda_nid_t pin_nid,
> +                              struct hdmi_eld *eld)
> +{
> +       int present = snd_hda_pin_sense(codec, pin_nid);
> +
> +       eld->monitor_present    = !!(present & AC_PINSENSE_PRESENCE);
> +       eld->eld_valid          = !!(present & AC_PINSENSE_ELDV);
> +
> +       if (present & AC_PINSENSE_ELDV)
> +               hdmi_get_show_eld(codec, pin_nid, eld);
> +}
> +
> +static int hdmi_add_pin(struct hda_codec *codec, hda_nid_t pin_nid)
> +{
> +       struct hdmi_spec *spec = codec->spec;
> +
> +       if (spec->num_pins >= MAX_HDMI_PINS) {
> +               snd_printk(KERN_WARNING
> +                          "HDMI: no space for pin %d \n", pin_nid);
> +               return -EINVAL;
> +       }
> +
> +       hdmi_present_sense(codec, pin_nid, &spec->sink_eld[spec->num_pins]);
> +
> +       spec->pin[spec->num_pins] = pin_nid;
> +       spec->num_pins++;
> +
> +       /*
> +        * It is assumed that converter nodes come first in the node list and
> +        * hence have been registered and usable now.
> +        */
> +       return hdmi_read_pin_conn(codec, pin_nid);
> +}
> +
> +static int hdmi_add_cvt(struct hda_codec *codec, hda_nid_t nid)
> +{
> +       struct hdmi_spec *spec = codec->spec;
> +
> +       if (spec->num_cvts >= MAX_HDMI_CVTS) {
> +               snd_printk(KERN_WARNING
> +                          "HDMI: no space for converter %d \n", nid);
> +               return -EINVAL;
> +       }
> +
> +       spec->cvt[spec->num_cvts] = nid;
> +       spec->num_cvts++;
> +
> +       return 0;
> +}
> +
> +static int hdmi_parse_codec(struct hda_codec *codec)
> +{
> +       hda_nid_t nid;
> +       int i, nodes;
> +
> +       nodes = snd_hda_get_sub_nodes(codec, codec->afg, &nid);
> +       if (!nid || nodes < 0) {
> +               snd_printk(KERN_WARNING "HDMI: failed to get afg sub nodes\n");
> +               return -EINVAL;
> +       }
> +
> +       for (i = 0; i < nodes; i++, nid++) {
> +               unsigned int caps;
> +               unsigned int type;
> +
> +               caps = snd_hda_param_read(codec, nid, AC_PAR_AUDIO_WIDGET_CAP);
> +               type = get_wcaps_type(caps);
> +
> +               if (!(caps & AC_WCAP_DIGITAL))
> +                       continue;
> +
> +               switch (type) {
> +               case AC_WID_AUD_OUT:
> +                       if (hdmi_add_cvt(codec, nid) < 0)
> +                               return -EINVAL;
> +                       break;
> +               case AC_WID_PIN:
> +                       caps = snd_hda_param_read(codec, nid, AC_PAR_PIN_CAP);
> +                       if (!(caps & (AC_PINCAP_HDMI | AC_PINCAP_DP)))
> +                               continue;
> +                       if (hdmi_add_pin(codec, nid) < 0)
> +                               return -EINVAL;
> +                       break;
> +               }
> +       }
> +
> +       /*
> +        * G45/IbexPeak don't support EPSS: the unsolicited pin hot plug event
> +        * can be lost and presence sense verb will become inaccurate if the
> +        * HDA link is powered off at hot plug or hw initialization time.
> +        */
> +#ifdef CONFIG_SND_HDA_POWER_SAVE
> +       if (!(snd_hda_param_read(codec, codec->afg, AC_PAR_POWER_STATE) &
> +             AC_PWRST_EPSS))
> +               codec->bus->power_keep_link_on = 1;
> +#endif
> +
> +       return 0;
> +}
> +
> --- sound-2.6.orig/sound/pci/hda/patch_nvhdmi.c 2010-03-04 13:14:54.000000000 +0800
> +++ sound-2.6/sound/pci/hda/patch_nvhdmi.c      2010-03-04 13:14:56.000000000 +0800
> @@ -29,6 +29,8 @@
>  #include "hda_codec.h"
>  #include "hda_local.h"
> 
> +#include "patch_hdmi.c"
> +
>  /* define below to restrict the supported rates and formats */
>  /* #define LIMITED_RATE_FMT_SUPPORT */
> 
> @@ -86,799 +88,16 @@ static struct hda_verb nvhdmi_basic_init
>  #define NVIDIA_89_HDMI_CVTS    1
>  #define NVIDIA_89_HDMI_PINS    1
> 
> -static char *nvhdmi_pcm_names[NVIDIA_89_HDMI_CVTS] = {
> +static char *nvhdmi_pcm_names[MAX_HDMI_CVTS] = {
>         "NVIDIA HDMI",
>  };
> 
> -struct nvhdmi_spec {
> -       int num_cvts;
> -       int num_pins;
> -       hda_nid_t cvt[NVIDIA_89_HDMI_CVTS+1];  /* audio sources */
> -       hda_nid_t pin[NVIDIA_89_HDMI_PINS+1];  /* audio sinks */
> -       hda_nid_t pin_cvt[NVIDIA_89_HDMI_PINS+1];
> -       struct hda_pcm pcm_rec[NVIDIA_89_HDMI_CVTS];
> -       struct hdmi_eld sink_eld[NVIDIA_89_HDMI_PINS];
> -       struct hda_multi_out multiout;
> -       unsigned int codec_type;
> -};
> -
> -struct hdmi_audio_infoframe {
> -       u8 type; /* 0x84 */
> -       u8 ver;  /* 0x01 */
> -       u8 len;  /* 0x0a */
> -
> -       u8 checksum;    /* PB0 */
> -       u8 CC02_CT47;   /* CC in bits 0:2, CT in 4:7 */
> -       u8 SS01_SF24;
> -       u8 CXT04;
> -       u8 CA;
> -       u8 LFEPBL01_LSV36_DM_INH7;
> -};
> -
> -/*
> - * CEA speaker placement:
> - *
> - *        FLH       FCH        FRH
> - *  FLW    FL  FLC   FC   FRC   FR   FRW
> - *
> - *                                  LFE
> - *                     TC
> - *
> - *          RL  RLC   RC   RRC   RR
> - *
> - * The Left/Right Surround channel _notions_ LS/RS in SMPTE 320M corresponds to
> - * CEA RL/RR; The SMPTE channel _assignment_ C/LFE is swapped to CEA LFE/FC.
> - */
> -enum cea_speaker_placement {
> -       FL  = (1 <<  0),        /* Front Left           */
> -       FC  = (1 <<  1),        /* Front Center         */
> -       FR  = (1 <<  2),        /* Front Right          */
> -       FLC = (1 <<  3),        /* Front Left Center    */
> -       FRC = (1 <<  4),        /* Front Right Center   */
> -       RL  = (1 <<  5),        /* Rear Left            */
> -       RC  = (1 <<  6),        /* Rear Center          */
> -       RR  = (1 <<  7),        /* Rear Right           */
> -       RLC = (1 <<  8),        /* Rear Left Center     */
> -       RRC = (1 <<  9),        /* Rear Right Center    */
> -       LFE = (1 << 10),        /* Low Frequency Effect */
> -       FLW = (1 << 11),        /* Front Left Wide      */
> -       FRW = (1 << 12),        /* Front Right Wide     */
> -       FLH = (1 << 13),        /* Front Left High      */
> -       FCH = (1 << 14),        /* Front Center High    */
> -       FRH = (1 << 15),        /* Front Right High     */
> -       TC  = (1 << 16),        /* Top Center           */
> -};
> -
> -/*
> - * ELD SA bits in the CEA Speaker Allocation data block
> - */
> -static int eld_speaker_allocation_bits[] = {
> -       [0] = FL | FR,
> -       [1] = LFE,
> -       [2] = FC,
> -       [3] = RL | RR,
> -       [4] = RC,
> -       [5] = FLC | FRC,
> -       [6] = RLC | RRC,
> -       /* the following are not defined in ELD yet */
> -       [7] = FLW | FRW,
> -       [8] = FLH | FRH,
> -       [9] = TC,
> -       [10] = FCH,
> -};
> -
> -struct cea_channel_speaker_allocation {
> -       int ca_index;
> -       int speakers[8];
> -
> -       /* derived values, just for convenience */
> -       int channels;
> -       int spk_mask;
> -};
> -
> -/*
> - * ALSA sequence is:
> - *
> - *       surround40   surround41   surround50   surround51   surround71
> - * ch0   front left   =            =            =            =
> - * ch1   front right  =            =            =            =
> - * ch2   rear left    =            =            =            =
> - * ch3   rear right   =            =            =            =
> - * ch4                LFE          center       center       center
> - * ch5                                          LFE          LFE
> - * ch6                                                       side left
> - * ch7                                                       side right
> - *
> - * surround71 = {FL, FR, RLC, RRC, FC, LFE, RL, RR}
> - */
> -static int hdmi_channel_mapping[0x32][8] = {
> -       /* stereo */
> -       [0x00] = { 0x00, 0x11, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7 },
> -       /* 2.1 */
> -       [0x01] = { 0x00, 0x11, 0x22, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7 },
> -       /* Dolby Surround */
> -       [0x02] = { 0x00, 0x11, 0x23, 0xf2, 0xf4, 0xf5, 0xf6, 0xf7 },
> -       /* surround40 */
> -       [0x08] = { 0x00, 0x11, 0x24, 0x35, 0xf3, 0xf2, 0xf6, 0xf7 },
> -       /* 4ch */
> -       [0x03] = { 0x00, 0x11, 0x23, 0x32, 0x44, 0xf5, 0xf6, 0xf7 },
> -       /* surround41 */
> -       [0x09] = { 0x00, 0x11, 0x24, 0x34, 0x43, 0xf2, 0xf6, 0xf7 },
> -       /* surround50 */
> -       [0x0a] = { 0x00, 0x11, 0x24, 0x35, 0x43, 0xf2, 0xf6, 0xf7 },
> -       /* surround51 */
> -       [0x0b] = { 0x00, 0x11, 0x24, 0x35, 0x43, 0x52, 0xf6, 0xf7 },
> -       /* 7.1 */
> -       [0x13] = { 0x00, 0x11, 0x32, 0x23, 0x64, 0x75, 0x46, 0x57 },
> -};
> -
> -/*
> - * This is an ordered list!
> - *
> - * The preceding ones have better chances to be selected by
> - * hdmi_setup_channel_allocation().
> - */
> -static struct cea_channel_speaker_allocation channel_allocations[] = {
> -/*                       channel:   7     6    5    4    3     2    1    0  */
> -{ .ca_index = 0x00,  .speakers = {   0,    0,   0,   0,   0,    0,  FR,  FL } },
> -                                /* 2.1 */
> -{ .ca_index = 0x01,  .speakers = {   0,    0,   0,   0,   0,  LFE,  FR,  FL } },
> -                                /* Dolby Surround */
> -{ .ca_index = 0x02,  .speakers = {   0,    0,   0,   0,  FC,    0,  FR,  FL } },
> -                                /* surround40 */
> -{ .ca_index = 0x08,  .speakers = {   0,    0,  RR,  RL,   0,    0,  FR,  FL } },
> -                                /* surround41 */
> -{ .ca_index = 0x09,  .speakers = {   0,    0,  RR,  RL,   0,  LFE,  FR,  FL } },
> -                                /* surround50 */
> -{ .ca_index = 0x0a,  .speakers = {   0,    0,  RR,  RL,  FC,    0,  FR,  FL } },
> -                                /* surround51 */
> -{ .ca_index = 0x0b,  .speakers = {   0,    0,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -                                /* 6.1 */
> -{ .ca_index = 0x0f,  .speakers = {   0,   RC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -                                /* surround71 */
> -{ .ca_index = 0x13,  .speakers = { RRC,  RLC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -
> -{ .ca_index = 0x03,  .speakers = {   0,    0,   0,   0,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x04,  .speakers = {   0,    0,   0,  RC,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x05,  .speakers = {   0,    0,   0,  RC,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x06,  .speakers = {   0,    0,   0,  RC,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x07,  .speakers = {   0,    0,   0,  RC,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x0c,  .speakers = {   0,   RC,  RR,  RL,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x0d,  .speakers = {   0,   RC,  RR,  RL,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x0e,  .speakers = {   0,   RC,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x10,  .speakers = { RRC,  RLC,  RR,  RL,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x11,  .speakers = { RRC,  RLC,  RR,  RL,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x12,  .speakers = { RRC,  RLC,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x14,  .speakers = { FRC,  FLC,   0,   0,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x15,  .speakers = { FRC,  FLC,   0,   0,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x16,  .speakers = { FRC,  FLC,   0,   0,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x17,  .speakers = { FRC,  FLC,   0,   0,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x18,  .speakers = { FRC,  FLC,   0,  RC,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x19,  .speakers = { FRC,  FLC,   0,  RC,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x1a,  .speakers = { FRC,  FLC,   0,  RC,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x1b,  .speakers = { FRC,  FLC,   0,  RC,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x1c,  .speakers = { FRC,  FLC,  RR,  RL,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x1d,  .speakers = { FRC,  FLC,  RR,  RL,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x1e,  .speakers = { FRC,  FLC,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x1f,  .speakers = { FRC,  FLC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x20,  .speakers = {   0,  FCH,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x21,  .speakers = {   0,  FCH,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x22,  .speakers = {  TC,    0,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x23,  .speakers = {  TC,    0,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x24,  .speakers = { FRH,  FLH,  RR,  RL,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x25,  .speakers = { FRH,  FLH,  RR,  RL,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x26,  .speakers = { FRW,  FLW,  RR,  RL,   0,    0,  FR,  FL } },
> -{ .ca_index = 0x27,  .speakers = { FRW,  FLW,  RR,  RL,   0,  LFE,  FR,  FL } },
> -{ .ca_index = 0x28,  .speakers = {  TC,   RC,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x29,  .speakers = {  TC,   RC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x2a,  .speakers = { FCH,   RC,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x2b,  .speakers = { FCH,   RC,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x2c,  .speakers = {  TC,  FCH,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x2d,  .speakers = {  TC,  FCH,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x2e,  .speakers = { FRH,  FLH,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x2f,  .speakers = { FRH,  FLH,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -{ .ca_index = 0x30,  .speakers = { FRW,  FLW,  RR,  RL,  FC,    0,  FR,  FL } },
> -{ .ca_index = 0x31,  .speakers = { FRW,  FLW,  RR,  RL,  FC,  LFE,  FR,  FL } },
> -};
> -
> -/*
> - * HDA/HDMI auto parsing
> - */
> -
> -static int hda_node_index(hda_nid_t *nids, hda_nid_t nid)
> -{
> -       int i;
> -
> -       for (i = 0; nids[i]; i++)
> -               if (nids[i] == nid)
> -                       return i;
> -
> -       snd_printk(KERN_WARNING "HDMI: nid %d not registered\n", nid);
> -       return -EINVAL;
> -}
> -
> -static int nvhdmi_read_pin_conn(struct hda_codec *codec, hda_nid_t pin_nid)
> -{
> -       struct nvhdmi_spec *spec = codec->spec;
> -       hda_nid_t conn_list[HDA_MAX_CONNECTIONS];
> -       int conn_len, curr;
> -       int index;
> -
> -       if (!(get_wcaps(codec, pin_nid) & AC_WCAP_CONN_LIST)) {
> -               snd_printk(KERN_WARNING
> -                          "HDMI: pin %d wcaps %#x "
> -                          "does not support connection list\n",
> -                          pin_nid, get_wcaps(codec, pin_nid));
> -               return -EINVAL;
> -       }
> -
> -       conn_len = snd_hda_get_connections(codec, pin_nid, conn_list,
> -                                          HDA_MAX_CONNECTIONS);
> -       if (conn_len > 1)
> -               curr = snd_hda_codec_read(codec, pin_nid, 0,
> -                                         AC_VERB_GET_CONNECT_SEL, 0);
> -       else
> -               curr = 0;
> -
> -       index = hda_node_index(spec->pin, pin_nid);
> -       if (index < 0)
> -               return -EINVAL;
> -
> -       spec->pin_cvt[index] = conn_list[curr];
> -
> -       return 0;
> -}
> -
> -static void hdmi_get_show_eld(struct hda_codec *codec, hda_nid_t pin_nid,
> -                             struct hdmi_eld *eld)
> -{
> -       if (!snd_hdmi_get_eld(eld, codec, pin_nid))
> -               snd_hdmi_show_eld(eld);
> -}
> -
> -static void hdmi_present_sense(struct hda_codec *codec, hda_nid_t pin_nid,
> -                              struct hdmi_eld *eld)
> -{
> -       int present = snd_hda_pin_sense(codec, pin_nid);
> -
> -       eld->monitor_present    = !!(present & AC_PINSENSE_PRESENCE);
> -       eld->eld_valid          = !!(present & AC_PINSENSE_ELDV);
> -
> -       if (present & AC_PINSENSE_ELDV)
> -               hdmi_get_show_eld(codec, pin_nid, eld);
> -}
> -
> -static int nvhdmi_add_pin(struct hda_codec *codec, hda_nid_t pin_nid)
> -{
> -       struct nvhdmi_spec *spec = codec->spec;
> -
> -       if (spec->num_pins >= NVIDIA_89_HDMI_PINS) {
> -               snd_printk(KERN_WARNING
> -                          "HDMI: no space for pin %d \n", pin_nid);
> -               return -EINVAL;
> -       }
> -
> -       hdmi_present_sense(codec, pin_nid, &spec->sink_eld[spec->num_pins]);
> -
> -       spec->pin[spec->num_pins] = pin_nid;
> -       spec->num_pins++;
> -
> -       /*
> -        * It is assumed that converter nodes come first in the node list and
> -        * hence have been registered and usable now.
> -        */
> -       return nvhdmi_read_pin_conn(codec, pin_nid);
> -}
> -
> -static int nvhdmi_add_cvt(struct hda_codec *codec, hda_nid_t nid)
> -{
> -       struct nvhdmi_spec *spec = codec->spec;
> -
> -       if (spec->num_cvts >= NVIDIA_89_HDMI_CVTS) {
> -               snd_printk(KERN_WARNING
> -                          "HDMI: no space for converter %d \n", nid);
> -               return -EINVAL;
> -       }
> -
> -       spec->cvt[spec->num_cvts] = nid;
> -       spec->num_cvts++;
> -
> -       return 0;
> -}
> -
> -
> -static int nvhdmi_parse_codec(struct hda_codec *codec)
> -{
> -       hda_nid_t nid;
> -       int i, nodes;
> -
> -       nodes = snd_hda_get_sub_nodes(codec, codec->afg, &nid);
> -       if (!nid || nodes < 0) {
> -               snd_printk(KERN_WARNING "HDMI: failed to get afg sub nodes\n");
> -               return -EINVAL;
> -       }
> -
> -       for (i = 0; i < nodes; i++, nid++) {
> -               unsigned int caps;
> -               unsigned int type;
> -
> -               caps = snd_hda_param_read(codec, nid, AC_PAR_AUDIO_WIDGET_CAP);
> -               type = get_wcaps_type(caps);
> -
> -               if (!(caps & AC_WCAP_DIGITAL))
> -                       continue;
> -
> -               switch (type) {
> -               case AC_WID_AUD_OUT:
> -                       if (nvhdmi_add_cvt(codec, nid) < 0)
> -                               return -EINVAL;
> -                       break;
> -               case AC_WID_PIN:
> -                       caps = snd_hda_param_read(codec, nid, AC_PAR_PIN_CAP);
> -                       if (!(caps & (AC_PINCAP_HDMI | AC_PINCAP_DP)))
> -                               continue;
> -                       if (nvhdmi_add_pin(codec, nid) < 0)
> -                               return -EINVAL;
> -                       break;
> -               }
> -       }
> -
> -       /*
> -        * G45/IbexPeak don't support EPSS: the unsolicited pin hot plug event
> -        * can be lost and presence sense verb will become inaccurate if the
> -        * HDA link is powered off at hot plug or hw initialization time.
> -        */
> -#ifdef CONFIG_SND_HDA_POWER_SAVE
> -       if (!(snd_hda_param_read(codec, codec->afg, AC_PAR_POWER_STATE) &
> -             AC_PWRST_EPSS))
> -               codec->bus->power_keep_link_on = 1;
> -#endif
> -
> -       return 0;
> -}
> -
> -/*
> - * HDMI routines
> - */
> -
> -#ifdef BE_PARANOID
> -static void hdmi_get_dip_index(struct hda_codec *codec, hda_nid_t pin_nid,
> -                               int *packet_index, int *byte_index)
> -{
> -       int val;
> -
> -       val = snd_hda_codec_read(codec, pin_nid, 0,
> -                                AC_VERB_GET_HDMI_DIP_INDEX, 0);
> -
> -       *packet_index = val >> 5;
> -       *byte_index = val & 0x1f;
> -}
> -#endif
> -
> -static void hdmi_set_dip_index(struct hda_codec *codec, hda_nid_t pin_nid,
> -                               int packet_index, int byte_index)
> -{
> -       int val;
> -
> -       val = (packet_index << 5) | (byte_index & 0x1f);
> -
> -       snd_hda_codec_write(codec, pin_nid, 0, AC_VERB_SET_HDMI_DIP_INDEX, val);
> -}
> -
> -static void hdmi_write_dip_byte(struct hda_codec *codec, hda_nid_t pin_nid,
> -                               unsigned char val)
> -{
> -       snd_hda_codec_write(codec, pin_nid, 0, AC_VERB_SET_HDMI_DIP_DATA, val);
> -}
> -
> -static void hdmi_enable_output(struct hda_codec *codec, hda_nid_t pin_nid)
> -{
> -       /* Unmute */
> -       if (get_wcaps(codec, pin_nid) & AC_WCAP_OUT_AMP)
> -               snd_hda_codec_write(codec, pin_nid, 0,
> -                               AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
> -       /* Enable pin out */
> -       snd_hda_codec_write(codec, pin_nid, 0,
> -                           AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
> -}
> -
> -/*
> - * Enable Audio InfoFrame Transmission
> - */
> -static void hdmi_start_infoframe_trans(struct hda_codec *codec,
> -                                      hda_nid_t pin_nid)
> -{
> -       hdmi_set_dip_index(codec, pin_nid, 0x0, 0x0);
> -       snd_hda_codec_write(codec, pin_nid, 0, AC_VERB_SET_HDMI_DIP_XMIT,
> -                                               AC_DIPXMIT_BEST);
> -}
> -
> -/*
> - * Disable Audio InfoFrame Transmission
> - */
> -static void hdmi_stop_infoframe_trans(struct hda_codec *codec,
> -                                     hda_nid_t pin_nid)
> -{
> -       hdmi_set_dip_index(codec, pin_nid, 0x0, 0x0);
> -       snd_hda_codec_write(codec, pin_nid, 0, AC_VERB_SET_HDMI_DIP_XMIT,
> -                                               AC_DIPXMIT_DISABLE);
> -}
> -
> -static int hdmi_get_channel_count(struct hda_codec *codec, hda_nid_t nid)
> -{
> -       return 1 + snd_hda_codec_read(codec, nid, 0,
> -                                       AC_VERB_GET_CVT_CHAN_COUNT, 0);
> -}
> -
> -static void hdmi_set_channel_count(struct hda_codec *codec,
> -                                  hda_nid_t nid, int chs)
> -{
> -       if (chs != hdmi_get_channel_count(codec, nid))
> -               snd_hda_codec_write(codec, nid, 0,
> -                                   AC_VERB_SET_CVT_CHAN_COUNT, chs - 1);
> -}
> -
> -static void hdmi_debug_channel_mapping(struct hda_codec *codec,
> -                                      hda_nid_t pin_nid)
> -{
> -#ifdef CONFIG_SND_DEBUG_VERBOSE
> -       int i;
> -       int slot;
> -
> -       for (i = 0; i < 8; i++) {
> -               slot = snd_hda_codec_read(codec, pin_nid, 0,
> -                                               AC_VERB_GET_HDMI_CHAN_SLOT, i);
> -               printk(KERN_DEBUG "HDMI: ASP channel %d => slot %d\n",
> -                                               slot >> 4, slot & 0xf);
> -       }
> -#endif
> -}
> -
> -
> -/*
> - * Audio InfoFrame routines
> - */
> -
> -static void hdmi_debug_dip_size(struct hda_codec *codec, hda_nid_t pin_nid)
> -{
> -#ifdef CONFIG_SND_DEBUG_VERBOSE
> -       int i;
> -       int size;
> -
> -       size = snd_hdmi_get_eld_size(codec, pin_nid);
> -       printk(KERN_DEBUG "HDMI: ELD buf size is %d\n", size);
> -
> -       for (i = 0; i < 8; i++) {
> -               size = snd_hda_codec_read(codec, pin_nid, 0,
> -                                               AC_VERB_GET_HDMI_DIP_SIZE, i);
> -               printk(KERN_DEBUG "HDMI: DIP GP[%d] buf size is %d\n", i, size);
> -       }
> -#endif
> -}
> -
> -static void hdmi_clear_dip_buffers(struct hda_codec *codec, hda_nid_t pin_nid)
> -{
> -#ifdef BE_PARANOID
> -       int i, j;
> -       int size;
> -       int pi, bi;
> -       for (i = 0; i < 8; i++) {
> -               size = snd_hda_codec_read(codec, pin_nid, 0,
> -                                               AC_VERB_GET_HDMI_DIP_SIZE, i);
> -               if (size == 0)
> -                       continue;
> -
> -               hdmi_set_dip_index(codec, pin_nid, i, 0x0);
> -               for (j = 1; j < 1000; j++) {
> -                       hdmi_write_dip_byte(codec, pin_nid, 0x0);
> -                       hdmi_get_dip_index(codec, pin_nid, &pi, &bi);
> -                       if (pi != i)
> -                               snd_printd(KERN_INFO "dip index %d: %d != %d\n",
> -                                               bi, pi, i);
> -                       if (bi == 0) /* byte index wrapped around */
> -                               break;
> -               }
> -               snd_printd(KERN_INFO
> -                       "HDMI: DIP GP[%d] buf reported size=%d, written=%d\n",
> -                       i, size, j);
> -       }
> -#endif
> -}
> -
> -static void hdmi_checksum_audio_infoframe(struct hdmi_audio_infoframe *ai)
> -{
> -       ai->checksum = 0;
> -}
> -
> -static void hdmi_fill_audio_infoframe(struct hda_codec *codec,
> -                                     hda_nid_t pin_nid,
> -                                     struct hdmi_audio_infoframe *ai)
> -{
> -       u8 *bytes = (u8 *)ai;
> -       int i;
> -
> -       hdmi_debug_dip_size(codec, pin_nid);
> -       hdmi_clear_dip_buffers(codec, pin_nid); /* be paranoid */
> -
> -       hdmi_checksum_audio_infoframe(ai);
> -
> -       hdmi_set_dip_index(codec, pin_nid, 0x0, 0x0);
> -       for (i = 0; i < sizeof(*ai); i++)
> -               hdmi_write_dip_byte(codec, pin_nid, bytes[i]);
> -}
> -
> -/*
> - * Compute derived values in channel_allocations[].
> - */
> -static void init_channel_allocations(void)
> -{
> -       int i, j;
> -       struct cea_channel_speaker_allocation *p;
> -
> -       for (i = 0; i < ARRAY_SIZE(channel_allocations); i++) {
> -               p = channel_allocations + i;
> -               p->channels = 0;
> -               p->spk_mask = 0;
> -               for (j = 0; j < ARRAY_SIZE(p->speakers); j++)
> -                       if (p->speakers[j]) {
> -                               p->channels++;
> -                               p->spk_mask |= p->speakers[j];
> -                       }
> -       }
> -}
> -
> -/*
> - * The transformation takes two steps:
> - *
> - *     eld->spk_alloc => (eld_speaker_allocation_bits[]) => spk_mask
> - *           spk_mask => (channel_allocations[])         => ai->CA
> - *
> - * TODO: it could select the wrong CA from multiple candidates.
> -*/
> -static int hdmi_setup_channel_allocation(struct hda_codec *codec, hda_nid_t nid,
> -                                        struct hdmi_audio_infoframe *ai)
> -{
> -       struct nvhdmi_spec *spec = codec->spec;
> -       struct hdmi_eld *eld;
> -       int i;
> -       int spk_mask = 0;
> -       int channels = 1 + (ai->CC02_CT47 & 0x7);
> -       char buf[SND_PRINT_CHANNEL_ALLOCATION_ADVISED_BUFSIZE];
> -
> -       /*
> -        * CA defaults to 0 for basic stereo audio
> -        */
> -       if (channels <= 2)
> -               return 0;
> -
> -       i = hda_node_index(spec->pin_cvt, nid);
> -       if (i < 0)
> -               return 0;
> -       eld = &spec->sink_eld[i];
> -
> -       /*
> -        * HDMI sink's ELD info cannot always be retrieved for now, e.g.
> -        * in console or for audio devices. Assume the highest speakers
> -        * configuration, to _not_ prohibit multi-channel audio playback.
> -        */
> -       if (!eld->spk_alloc)
> -               eld->spk_alloc = 0xffff;
> -
> -       /*
> -        * expand ELD's speaker allocation mask
> -        *
> -        * ELD tells the speaker mask in a compact(paired) form,
> -        * expand ELD's notions to match the ones used by Audio InfoFrame.
> -        */
> -       for (i = 0; i < ARRAY_SIZE(eld_speaker_allocation_bits); i++) {
> -               if (eld->spk_alloc & (1 << i))
> -                       spk_mask |= eld_speaker_allocation_bits[i];
> -       }
> -
> -       /* search for the first working match in the CA table */
> -       for (i = 0; i < ARRAY_SIZE(channel_allocations); i++) {
> -               if (channels == channel_allocations[i].channels &&
> -                   (spk_mask & channel_allocations[i].spk_mask) ==
> -                               channel_allocations[i].spk_mask) {
> -                       ai->CA = channel_allocations[i].ca_index;
> -                       break;
> -               }
> -       }
> -
> -       snd_print_channel_allocation(eld->spk_alloc, buf, sizeof(buf));
> -       snd_printdd(KERN_INFO
> -                       "HDMI: select CA 0x%x for %d-channel allocation: %s\n",
> -                       ai->CA, channels, buf);
> -
> -       return ai->CA;
> -}
> -
> -static void hdmi_setup_channel_mapping(struct hda_codec *codec,
> -                                      hda_nid_t pin_nid,
> -                                      struct hdmi_audio_infoframe *ai)
> -{
> -       int i;
> -       int ca = ai->CA;
> -       int err;
> -
> -       if (hdmi_channel_mapping[ca][1] == 0) {
> -               for (i = 0; i < channel_allocations[ca].channels; i++)
> -                       hdmi_channel_mapping[ca][i] = i | (i << 4);
> -               for (; i < 8; i++)
> -                       hdmi_channel_mapping[ca][i] = 0xf | (i << 4);
> -       }
> -
> -       for (i = 0; i < 8; i++) {
> -               err = snd_hda_codec_write(codec, pin_nid, 0,
> -                                         AC_VERB_SET_HDMI_CHAN_SLOT,
> -                                         hdmi_channel_mapping[ca][i]);
> -               if (err) {
> -                       snd_printdd(KERN_INFO "HDMI: channel mapping failed\n");
> -                       break;
> -               }
> -       }
> -
> -       hdmi_debug_channel_mapping(codec, pin_nid);
> -}
> -
> -static bool hdmi_infoframe_uptodate(struct hda_codec *codec, hda_nid_t pin_nid,
> -                                   struct hdmi_audio_infoframe *ai)
> -{
> -       u8 *bytes = (u8 *)ai;
> -       u8 val;
> -       int i;
> -
> -       if (snd_hda_codec_read(codec, pin_nid, 0, AC_VERB_GET_HDMI_DIP_XMIT, 0)
> -                                                           != AC_DIPXMIT_BEST)
> -               return false;
> -
> -       hdmi_set_dip_index(codec, pin_nid, 0x0, 0x0);
> -       for (i = 0; i < sizeof(*ai); i++) {
> -               val = snd_hda_codec_read(codec, pin_nid, 0,
> -                                        AC_VERB_GET_HDMI_DIP_DATA, 0);
> -               if (val != bytes[i])
> -                       return false;
> -       }
> -
> -       return true;
> -}
> -
> -static void hdmi_setup_audio_infoframe(struct hda_codec *codec, hda_nid_t nid,
> -                                       struct snd_pcm_substream *substream)
> -{
> -       struct nvhdmi_spec *spec = codec->spec;
> -       hda_nid_t pin_nid;
> -       int i;
> -       struct hdmi_audio_infoframe ai = {
> -               .type           = 0x84,
> -               .ver            = 0x01,
> -               .len            = 0x0a,
> -               .CC02_CT47      = substream->runtime->channels - 1,
> -       };
> -
> -       hdmi_setup_channel_allocation(codec, nid, &ai);
> -
> -       for (i = 0; i < spec->num_pins; i++) {
> -               if (spec->pin_cvt[i] != nid)
> -                       continue;
> -               if (!spec->sink_eld[i].monitor_present)
> -                       continue;
> -
> -               pin_nid = spec->pin[i];
> -               if (!hdmi_infoframe_uptodate(codec, pin_nid, &ai)) {
> -                       hdmi_setup_channel_mapping(codec, pin_nid, &ai);
> -                       hdmi_stop_infoframe_trans(codec, pin_nid);
> -                       hdmi_fill_audio_infoframe(codec, pin_nid, &ai);
> -                       hdmi_start_infoframe_trans(codec, pin_nid);
> -               }
> -       }
> -}
> -
> -/*
> - * Unsolicited events
> - */
> -
> -static void hdmi_intrinsic_event(struct hda_codec *codec, unsigned int res)
> -{
> -       struct nvhdmi_spec *spec = codec->spec;
> -       int tag = res >> AC_UNSOL_RES_TAG_SHIFT;
> -       int pind = !!(res & AC_UNSOL_RES_PD);
> -       int eldv = !!(res & AC_UNSOL_RES_ELDV);
> -       int index;
> -
> -       printk(KERN_INFO
> -               "HDMI hot plug event: Pin=%d Presence_Detect=%d ELD_Valid=%d\n",
> -               tag, pind, eldv);
> -
> -       index = hda_node_index(spec->pin, tag);
> -       if (index < 0)
> -               return;
> -
> -       spec->sink_eld[index].monitor_present = pind;
> -       spec->sink_eld[index].eld_valid = eldv;
> -
> -       if (eldv) {
> -               spec->sink_eld[index].monitor_present = 1;
> -               hdmi_get_show_eld(codec, spec->pin[index],
> -                                &spec->sink_eld[index]);
> -               /* TODO: do real things about ELD */
> -       }
> -}
> -
> -static void hdmi_non_intrinsic_event(struct hda_codec *codec, unsigned int res)
> -{
> -       int tag = res >> AC_UNSOL_RES_TAG_SHIFT;
> -       int subtag = (res & AC_UNSOL_RES_SUBTAG) >> AC_UNSOL_RES_SUBTAG_SHIFT;
> -       int cp_state = !!(res & AC_UNSOL_RES_CP_STATE);
> -       int cp_ready = !!(res & AC_UNSOL_RES_CP_READY);
> -
> -       printk(KERN_INFO
> -               "HDMI CP event: PIN=%d SUBTAG=0x%x CP_STATE=%d CP_READY=%d\n",
> -               tag,
> -               subtag,
> -               cp_state,
> -               cp_ready);
> -
> -       /* TODO */
> -       if (cp_state)
> -               ;
> -       if (cp_ready)
> -               ;
> -}
> -
> -static void nvhdmi_unsol_event(struct hda_codec *codec, unsigned int res)
> -{
> -       struct nvhdmi_spec *spec = codec->spec;
> -       int tag = res >> AC_UNSOL_RES_TAG_SHIFT;
> -       int subtag = (res & AC_UNSOL_RES_SUBTAG) >> AC_UNSOL_RES_SUBTAG_SHIFT;
> -
> -       if (hda_node_index(spec->pin, tag) < 0) {
> -               snd_printd(KERN_INFO "Unexpected HDMI event tag 0x%x\n", tag);
> -               return;
> -       }
> -
> -       if (subtag == 0)
> -               hdmi_intrinsic_event(codec, res);
> -       else
> -               hdmi_non_intrinsic_event(codec, res);
> -}
> -
> -/*
> - * Callbacks
> - */
> -
> -static void hdmi_setup_stream(struct hda_codec *codec, hda_nid_t nid,
> -                             u32 stream_tag, int format)
> -{
> -       int tag;
> -       int fmt;
> -
> -       tag = snd_hda_codec_read(codec, nid, 0, AC_VERB_GET_CONV, 0) >> 4;
> -       fmt = snd_hda_codec_read(codec, nid, 0, AC_VERB_GET_STREAM_FORMAT, 0);
> -
> -       snd_printdd("hdmi_setup_stream: "
> -                   "NID=0x%x, %sstream=0x%x, %sformat=0x%x\n",
> -                   nid,
> -                   tag == stream_tag ? "" : "new-",
> -                   stream_tag,
> -                   fmt == format ? "" : "new-",
> -                   format);
> -
> -       if (tag != stream_tag)
> -               snd_hda_codec_write(codec, nid, 0,
> -                                   AC_VERB_SET_CHANNEL_STREAMID,
> -                                   stream_tag << 4);
> -       if (fmt != format)
> -               snd_hda_codec_write(codec, nid, 0,
> -                                   AC_VERB_SET_STREAM_FORMAT, format);
> -}
> -
>  /*
>   * Controls
>   */
>  static int nvhdmi_build_controls(struct hda_codec *codec)
>  {
> -       struct nvhdmi_spec *spec = codec->spec;
> +       struct hdmi_spec *spec = codec->spec;
>         int err;
>         int i;
> 
> @@ -902,7 +121,7 @@ static int nvhdmi_build_controls(struct
> 
>  static int nvhdmi_init(struct hda_codec *codec)
>  {
> -       struct nvhdmi_spec *spec = codec->spec;
> +       struct hdmi_spec *spec = codec->spec;
>         int i;
>         if ((spec->codec_type == HDA_CODEC_NVIDIA_MCP89)
>         || (spec->codec_type == HDA_CODEC_NVIDIA_GT21X)) {
> @@ -920,7 +139,7 @@ static int nvhdmi_init(struct hda_codec
> 
>  static void nvhdmi_free(struct hda_codec *codec)
>  {
> -       struct nvhdmi_spec *spec = codec->spec;
> +       struct hdmi_spec *spec = codec->spec;
>         int i;
> 
>         if ((spec->codec_type == HDA_CODEC_NVIDIA_MCP89)
> @@ -939,7 +158,7 @@ static int nvhdmi_dig_playback_pcm_open(
>                                         struct hda_codec *codec,
>                                         struct snd_pcm_substream *substream)
>  {
> -       struct nvhdmi_spec *spec = codec->spec;
> +       struct hdmi_spec *spec = codec->spec;
>         return snd_hda_multi_out_dig_open(codec, &spec->multiout);
>  }
> 
> @@ -947,7 +166,7 @@ static int nvhdmi_dig_playback_pcm_close
>                                         struct hda_codec *codec,
>                                         struct snd_pcm_substream *substream)
>  {
> -       struct nvhdmi_spec *spec = codec->spec;
> +       struct hdmi_spec *spec = codec->spec;
>         int i;
> 
>         snd_hda_codec_write(codec, nvhdmi_master_con_nid_7x,
> @@ -968,7 +187,7 @@ static int nvhdmi_dig_playback_pcm_close
>                                         struct hda_codec *codec,
>                                         struct snd_pcm_substream *substream)
>  {
> -       struct nvhdmi_spec *spec = codec->spec;
> +       struct hdmi_spec *spec = codec->spec;
>         return snd_hda_multi_out_dig_close(codec, &spec->multiout);
>  }
> 
> @@ -1121,7 +340,7 @@ static int nvhdmi_dig_playback_pcm_prepa
>                                         unsigned int format,
>                                         struct snd_pcm_substream *substream)
>  {
> -       struct nvhdmi_spec *spec = codec->spec;
> +       struct hdmi_spec *spec = codec->spec;
>         return snd_hda_multi_out_dig_prepare(codec, &spec->multiout, stream_tag,
>                                         format, substream);
>  }
> @@ -1170,7 +389,7 @@ static struct hda_pcm_stream nvhdmi_pcm_
> 
>  static int nvhdmi_build_pcms_8ch_89(struct hda_codec *codec)
>  {
> -       struct nvhdmi_spec *spec = codec->spec;
> +       struct hdmi_spec *spec = codec->spec;
>         struct hda_pcm *info = spec->pcm_rec;
>         int i;
> 
> @@ -1196,7 +415,7 @@ static int nvhdmi_build_pcms_8ch_89(stru
> 
>  static int nvhdmi_build_pcms_8ch_7x(struct hda_codec *codec)
>  {
> -       struct nvhdmi_spec *spec = codec->spec;
> +       struct hdmi_spec *spec = codec->spec;
>         struct hda_pcm *info = spec->pcm_rec;
> 
>         codec->num_pcms = 1;
> @@ -1212,7 +431,7 @@ static int nvhdmi_build_pcms_8ch_7x(stru
> 
>  static int nvhdmi_build_pcms_2ch(struct hda_codec *codec)
>  {
> -       struct nvhdmi_spec *spec = codec->spec;
> +       struct hdmi_spec *spec = codec->spec;
>         struct hda_pcm *info = spec->pcm_rec;
> 
>         codec->num_pcms = 1;
> @@ -1231,7 +450,7 @@ static struct hda_codec_ops nvhdmi_patch
>         .build_pcms = nvhdmi_build_pcms_8ch_89,
>         .init = nvhdmi_init,
>         .free = nvhdmi_free,
> -       .unsol_event = nvhdmi_unsol_event,
> +       .unsol_event = hdmi_unsol_event,
>  };
> 
>  static struct hda_codec_ops nvhdmi_patch_ops_8ch_7x = {
> @@ -1250,7 +469,7 @@ static struct hda_codec_ops nvhdmi_patch
> 
>  static int patch_nvhdmi_8ch_89(struct hda_codec *codec)
>  {
> -       struct nvhdmi_spec *spec;
> +       struct hdmi_spec *spec;
>         int i;
> 
>         spec = kzalloc(sizeof(*spec), GFP_KERNEL);
> @@ -1260,7 +479,7 @@ static int patch_nvhdmi_8ch_89(struct hd
>         codec->spec = spec;
>         spec->codec_type = HDA_CODEC_NVIDIA_MCP89;
> 
> -       if (nvhdmi_parse_codec(codec) < 0) {
> +       if (hdmi_parse_codec(codec) < 0) {
>                 codec->spec = NULL;
>                 kfree(spec);
>                 return -EINVAL;
> @@ -1277,7 +496,7 @@ static int patch_nvhdmi_8ch_89(struct hd
> 
>  static int patch_nvhdmi_8ch_7x(struct hda_codec *codec)
>  {
> -       struct nvhdmi_spec *spec;
> +       struct hdmi_spec *spec;
> 
>         spec = kzalloc(sizeof(*spec), GFP_KERNEL);
>         if (spec == NULL)
> @@ -1297,7 +516,7 @@ static int patch_nvhdmi_8ch_7x(struct hd
> 
>  static int patch_nvhdmi_2ch(struct hda_codec *codec)
>  {
> -       struct nvhdmi_spec *spec;
> +       struct hdmi_spec *spec;
> 
>         spec = kzalloc(sizeof(*spec), GFP_KERNEL);
>         if (spec == NULL)

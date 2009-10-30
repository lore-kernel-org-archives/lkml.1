Return-Path: <linux-kernel-owner+w=401wt.eu-S932867AbZJ3Szz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867AbZJ3Szz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 14:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbZJ3Szz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 14:55:55 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51344 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330AbZJ3Szy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 14:55:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RcHqcfYawsiX8lDmzEAsr6XusBJ/1RSvZn9GUYF49UO1qxWmbgnqYshCxL3GLZFQ7Y
         TKkRs846WrEoi13p5e9EfbjKblrItIdRaHmxS/VAbvXlg2drp08Eq9XX9aszenEODI3Z
         +eOoYZBq+7tul74FAl0dO9v0mX72zPuGnSqvc=
MIME-Version: 1.0
In-Reply-To: <20091030083742.48f5d4f3@jbarnes-g45>
References: <cb0375e10910030939v8d03df7m861a2f05219f173c@mail.gmail.com>
	 <cb0375e10910030950kcd19fe9i7835eaaf4314c0fb@mail.gmail.com>
	 <20091005092148.4341d9ab@jbarnes-g45>
	 <cb0375e10910072044m470c8cbasef33de3b36bb62ee@mail.gmail.com>
	 <20091029094723.7e5a3376@jbarnes-g45>
	 <cb0375e10910291022l5650994dyc4a36d55f1e5bbc4@mail.gmail.com>
	 <cb0375e10910291040i31a7b9aatb6da5c20778d9791@mail.gmail.com>
	 <cb0375e10910292325l659034c4u36cf263cda8e90c8@mail.gmail.com>
	 <20091030083742.48f5d4f3@jbarnes-g45>
Date: Fri, 30 Oct 2009 14:55:57 -0400
X-Google-Sender-Auth: e9d1a03f9c9363bf
Message-ID: <cb0375e10910301155s5e2b2e79t562bfa798ba75e23@mail.gmail.com>
Subject: Re: [resend] i915: high power consumption after suspend/resume
From: Andrew Lutomirski <luto@mit.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 11:37 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Fri, 30 Oct 2009 02:25:21 -0400
> Andrew Lutomirski <luto@mit.edu> wrote:
>
>> On Thu, Oct 29, 2009 at 1:40 PM, Andrew Lutomirski <luto@mit.edu>
>> wrote:
>> >
>> > I just suspended and resumed and power consumption stayed low.  I'll
>> > try and get an intel_reg_dumper diff next time I trigger this bug.
>>
>> intel_reg_dumper blames RENCLK_GATE_D2.  Patch coming.
>>
>> Maybe my BIOS doesn't always reset it.
>
> Does resetting that reg get your power savings back?

Surprisingly, no.  With my kernel patched to restore it on resume, I
still see high power consumption, and rebinding still fixes it.  (As
an aside, I think hat i915's ability to survive rebinding without
crashing on the next X startup has gotten worse recently.  I
invariably OOPS awhile after rebinding with recent kernels.)

I diffed the output of intel_reg_dumper (2.9.0, I think):


--- /tmp/pre-rebind     2009-10-30 14:35:24.267236469 -0400
+++ /tmp/post-rebind    2009-10-30 14:39:22.649986477 -0400
@@ -46,7 +46,7 @@
 (II):         PFIT_CONTROL: 0x00000000
 (II):      PFIT_PGM_RATIOS: 0x00000000
 (II):      PORT_HOTPLUG_EN: 0x3e040320
-(II):    PORT_HOTPLUG_STAT: 0x38560800
+(II):    PORT_HOTPLUG_STAT: 0x38000000
 (II):             DSPACNTR: 0x00000000 (disabled, pipe A)
 (II):           DSPASTRIDE: 0x00000000 (0 bytes)
 (II):              DSPAPOS: 0x00000000 (0, 0)
@@ -149,7 +149,7 @@
 (II):          FBC_COMMAND: 0x08c80034
 (II):           FBC_STATUS: 0x00000000
 (II):         FBC_CONTROL2: 0x00000000
-(II):        FBC_FENCE_OFF: 0x00008000
+(II):        FBC_FENCE_OFF: 0x10000000
 (II):          FBC_MOD_NUM: 0x00000060
 (II):              MI_MODE: 0x00000200
 (II):         MI_ARB_STATE: 0x00000040

intel_reg_write doesn't seem to work right on FBC_FENCE_OFF (previous
value doesn't agree w/ intel_reg_dumper), and I'm not sure exactly
what that's supposed to do.

--Andy

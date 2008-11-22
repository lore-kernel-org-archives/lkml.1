Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbYKVJv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbYKVJv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 04:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYKVJvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 04:51:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:51202 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYKVJvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 04:51:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:to:cc:in-reply-to:references:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding:from;
        b=XiGO9lfKCVdvZkDhINjsASVcVN9ZKOwBjR1/y5chnnz42iub6ZeyHKpRDy/ElxKTIB
         f3UlDj5bzWwE5Utn7lS//vrW4QJ9Zq1tz3sAcTgvDkdb9zZniOGobHhVWDNiSlWfWB/5
         MYdSnZzNvLXzRCaZm0LTG77JBO5kJ4xs+uN6o=
Subject: Re: debugctl msr
To: eranian@gmail.com
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Markus Metzger <markus.t.metzger@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <7c86c4470811211447p57b38ecy9520a9e5170d2ce1@mail.gmail.com>
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <1227119245.6025.12.camel@raistlin>
	 <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
	 <1227133570.6104.10.camel@raistlin>
	 <7c86c4470811201319x2eb93d41vbdd8ce480a797fab@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F115BC@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811210538i5e6958e1p2c31effa762f5914@mail.gmail.com>
	 <7c86c4470811210727o13006d5bk5bcbacb791e51b1c@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F3B93D@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811210833l5c8005b4l675bc51df50affaa@mail.gmail.com>
	 <7c86c4470811211447p57b38ecy9520a9e5170d2ce1@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 22 Nov 2008 10:51:31 +0100
Message-Id: <1227347491.6146.13.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
From: Markus Metzger <markus.t.metzger@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-21 at 23:47 +0100, stephane eranian wrote:


> With the current code base, ds.c can accept a pre-allocated buffer.
> However, it does
> some adjustments for alignment and size (multiple of PEBS record
> size). That means
> that the start and end of the buffer could be different from the area
> passed to ds_request_pebs().
> 
> To parse the buffer, a monitoring tools needs a start position and the
> number of samples. The start
> position can be expressed as an offset from the beginning of the
> perfmon buffer.  The ds.c interface
> currently only returns indexes for current position, threshold, and
> end. Those indexes are good enough
> to derived the number of samples. But I would need one call to return
> the byte offset from the original
> buffer, or the actual address (which perfmon could then convert back
> to an offset from its buffer).

ds_access() returns the pointer into the raw buffer at a given index.
For index 0, this is the beginning of the buffer.


I plan to replace the various access functions with a single one that
returns a const pointer to the configuration.

Something like:

struct ds_config {
  size_t number_of_records;
  size_t size_of_a_single_record;
  void *base;
  void *max;
  void *index;
  void *threshold;
};

const struct ds_config *ds_config_pebs(struct pebs_tracer *tracer);

For BTS, I would add functions to work on this struct and translate raw
entries into an architecture-independent format.
I'm not sure whether this would make sense for PEBS, as well.

Would you be OK with such a change?


thanks and regards,
markus.



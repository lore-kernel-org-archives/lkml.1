Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbZHYScE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbZHYScE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbZHYScE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:32:04 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:2517 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbZHYScC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:32:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pZ2aEL94rXZKTF67PWTjgcgNjZhLHtSIgcBi1oIObQnr5DlXwQuLdotO9dh9yyx+w9
         1q6wWt1+SHVP+8Eev4NsMd8MMRPeNknygQClCUYYNzROJY8IY2o1Z7mTw3Ty0AdgBsXV
         2133f9Mh/l6+q8n1IFbfvBTkthc2qOgL6gXwE=
Date: Tue, 25 Aug 2009 22:31:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>,
       Yinghai Lu <yinghai@kernel.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, shai@scalex86.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090825183130.GA5806@lenovo>
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825181500.GB3277@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, Aug 25, 2009 at 08:15:00PM +0200]
| 
| * Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
| 
| > On Mon, Aug 24, 2009 at 10:12:01PM -0700, Yinghai Lu wrote:
| > >Ravikiran G Thirumalai wrote:
| > >> On Mon, Aug 24, 2009 at 04:53:45PM -0700, Yinghai Lu wrote:
| > >>> Ravikiran G Thirumalai wrote:
| > >>>> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
| > >>>> Cc: Yinghai Lu <yinghai@kernel.org>
| > >>>>
| > >>>
| > >> 
| > >> Why?  The specs seem to indicate otherwise unless I am mistaken --
| > >> Intel  systems programming guide, Vol 3A Part1, chapter 7 section
| > >> 7.5.5 - Identifying Logical Processors in a MP system:
| > >> <quote>
| > >> After the BIOS has completed the MP initialization protocol, each logical
| > >> processor can be uniquely identified by its local APIC ID. Software can
| > >> access these APIC IDs in either of the following ways
| > >> </quote>
| > >> phys_pkg_id() indicates that the logical package id is being looked up,
| > >> so local apic id should be used here no?
| > >> What am I missing?
| > >
| > >initial apic id : it can not changed, there is fixed mapping from that to physical processor id aka socket id / node id.
| > >
| > >apic id: could be changed by BIOS to any value. there is no good way to get phys_pkg_id from that.
| > >
| > 
| > But BIOS is supposed to change it to a sane value.  Until 2.6.30, 
| > local apic id has been used to get phys_pkg_id for the 'flat' 
| > apics!  What changed?  Was this changed for a BIOS bug?  Even the 
| > intel books seem to indicate local apic usage!
| 
| We should revert to the .30 behavior unless there's a good reason 
| (even in that case we'll solve the regression and do a workaround 
| for vSMP). Yinghai?
| 
| 	Ingo

I'm definitely not APIC expert but since I was partially involved
letme turn in.

Original commit which causes problem for vSMP seems to be due
to cpu_has_apic bit turned off (ie due to being manually disabled
or acpi table broken) so further read apic id will return plain
zero (we're talking about 64 bits now). So frnakly I don't understand
what is wrong with Ravikiran's patch. In case of apic disabled
initial apic value will be used anyway (which is latched but
actually may be changed, but it's not our case).

Or perhaps there is an issue in srat numa nodes numbering?

	-- Cyrill

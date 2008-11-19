Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbYKSM7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbYKSM7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 07:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYKSM7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 07:59:33 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:52978 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbYKSM7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 07:59:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=IqR1IOAoSBUzYV/hG3xiaY75uuvAU6JPOTeVHtH+Mmp2sX1kQuTXJx61yYGEOu1sga
         igWkGBJKE7Dztg6F9TYhU/Hr49MY+CiEFo5A0fhdNZJsr3FdeToyZYtTFhQO33KBMUk4
         6f7GHkNMRfwiCOpZBrVDodO8zTWF4hCcZav28=
Message-ID: <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
Date: Wed, 19 Nov 2008 13:59:30 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: debugctl msr
Cc: "Markus Metzger" <markus.t.metzger@googlemail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E08F10AAA@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <491A812D.9010208@gmail.com>
	 <7c86c4470811120210j2ea5ccdcv59a654aadc32ebd2@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B1F123@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811130650j4192c63n1fa9800a0cdfb93c@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B595A3@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811141310h4fd3c5fbvc6357985cf2aed0e@mail.gmail.com>
	 <1226743286.6162.6.camel@raistlin>
	 <7c86c4470811181400r1fa56ef9o1931467ee10e4f52@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10AAA@irsmsx504.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,


You are right about the reserved field, it was missing from my code
but that was harmless.

I had to hack ds.c some more to make forward progress with PEBS. First
of all my PEBS code is
in a kernel module, so all PEBS functions have to be exported.
Furhtermore, I need a
ds_get_pebs_thres() and ds_set_pebs_thres() calls.

But the one key problem is ds_validate_access(). I had to disable this
function. The problem is that
with perfmon there can be several threads who need access to the PEBS
fields. Take the simple
case of a tool attaching to a running process to attach the monitoring
harness. The tool's thread
is called ds_request_pebs(), so it is marked as the owner. But on PEBS
buffer full overflow, the
monitored thread is the current thread and it needs to know the
position in the buffer, therefore
it calls ds_get_pebs_index(). With perfmon a session is identified by
a file descriptor, any thread
with access to the file descriptor can access the session's data and
thus may need PEBS access.
For instance, if the monitoring tool is multi-threaded, then any
thread can access the PEBS data.


On Wed, Nov 19, 2008 at 1:14 PM, Metzger, Markus T
<markus.t.metzger@intel.com> wrote:
>>-----Original Message-----
>>From: stephane eranian [mailto:eranian@googlemail.com]
>>Sent: Dienstag, 18. November 2008 23:01
>>To: Markus Metzger
>>Cc: Metzger, Markus T; Ingo Molnar; Andi Kleen; Andrew Morton;
>>linux-kernel@vger.kernel.org
>>Subject: Re: debugctl msr
>>
>
>>I think your definition for ds_cfg_64 is wrong. On Core, the PEBS
>>record ALWAYS includes r8-r15 even on
>>32 bits (zero filled). Also the DS_AREA has 9 fields, not 8.
>>Consequently, I think the structure should be defined
>>as follows:
>>
>>static const struct ds_configuration ds_cfg_64 = {
>>        .sizeof_ds    = 8 * 9,
>
> You are right that there are 9 fields.
> However, the 9th field is double the size of the other fields and the entire structure is padded.
> The original code should read 8 * 12 to reflect that.
>
>>        .sizeof_field = 8,
>>        .sizeof_rec[ds_bts]   = 8 * 3,
>>        .sizeof_rec[ds_pebs]  = 8 * 18
>
> You're right about the PEBS size.
>
> I will send a patch some time this week.
>
> thanks,
> markus.
> ---------------------------------------------------------------------
> Intel GmbH
> Dornacher Strasse 1
> 85622 Feldkirchen/Muenchen Germany
> Sitz der Gesellschaft: Feldkirchen bei Muenchen
> Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
> Registergericht: Muenchen HRB 47456 Ust.-IdNr.
> VAT Registration No.: DE129385895
> Citibank Frankfurt (BLZ 502 109 00) 600119052
>
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
>
>

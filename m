Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbZCSRUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbZCSRUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbZCSRUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:20:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:42948 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZCSRUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:20:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=imYGTCOzM6Hm6lOHMQ4OG5vlRpT+V6IOgQr3oSdXWdxY4RZ0YH3/ZTPVSr82kvBBcb
         uNjgO27RnTWWWlCM5q0GCJEbbvuqxngE/G9aG0w6C/MyIhpInCmhfoR2egYxFX/vSrrR
         LNM/90em2wg4IO0/ADDviCVIlG0iJgnAlVxzA=
MIME-Version: 1.0
In-Reply-To: <49C26D91.10804@intel.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>
	 <49C26D91.10804@intel.com>
Date: Thu, 19 Mar 2009 10:20:19 -0700
X-Google-Sender-Auth: c0e479f3d2beef72
Message-ID: <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 
	multiplication
From: Dan Williams <dan.j.williams@intel.com>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
       maciej.sosnowski@intel.com, Ilya Yanok <yanok@emcraft.com>,
       Yuri Tikhonov <yur@emcraft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 9:06 AM, H. Peter Anvin <h.peter.anvin@intel.com> wrote:
> Dan Williams wrote:
>> + * @scfs: array of source coefficients used in GF-multiplication
>
> Array of source coefficients?  Are you doing a vector-vector
> multiplication here?
>
> Given this code:
>
>>       for (d = 0; d < len; d++) {
>> +             wq = wp = ptrs[0][d];
>> +             for (z = 1; z < src_cnt; z++) {
>> +                     wd = ptrs[z][d];
>> +                     wp ^= wd;
>> +                     wq ^= raid6_gfmul[scfs[z]][wd];
>> +             }
>
> ... it kinds of looks like that.
>
> This is really quite expensive!  The whole point of the restore code
> that exists is that we never do a two-dimensional lookup, instead
> caching a pointer to the multiplication table that we intend to use,
> because the RAID-6 code only ever contains scalar-vector multiplications.
>
> I really don't get this, and I think it's broken.

Something is broken if we take this path.  This routine could stand to
have a WARN_ONCE(), because if it is ever called there is something is
wrong with the raid6 offload driver.  The intent is that the
asynchronous recovery routines will perform an early check to see if
the recovery can be offloaded (with a series of calls to
async_xor/async_pq).  If not we fall back to the optimized synchronous
recovery routines (raid6_2data_recov, raid6_datap_recov).  The only
time this path will be taken is if we have decided to perform
asynchronous recovery but at a later call to async_pq the offload
driver reports it has run out of descriptors.

--
Dan

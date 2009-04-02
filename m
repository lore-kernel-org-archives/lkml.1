Return-Path: <linux-kernel-owner+w=401wt.eu-S935541AbZDBJ6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935541AbZDBJ6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbZDBJ62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:58:28 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:21342 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316AbZDBJ61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:58:27 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNbdalLaF0lu
X-RZG-CLASS-ID: mo05
Message-ID: <49D48C3C.5060803@ursus.ath.cx>
Date: Thu, 02 Apr 2009 11:58:20 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: david@lang.hm
CC: Bron Gondwana <brong@fastmail.fm>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
References: <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <gqr50k$4aq$1@ger.gmane.org> <alpine.DEB.1.10.0903311813390.28893@asgard.lang.hm> <49D3954A.9010309@tmr.com> <alpine.DEB.1.10.0904011311240.28893@asgard.lang.hm> <49D3DDBF.9060406@ursus.ath.cx> <alpine.DEB.1.10.0904011528100.28893@asgard.lang.hm> <20090402023040.GA20071@brong.net> <alpine.DEB.1.10.0904012145450.30587@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0904012145450.30587@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02.04.2009 06:55 david@lang.hm wrote:
> On Thu, 2 Apr 2009, Bron Gondwana wrote:
>
>   
>> On Wed, Apr 01, 2009 at 03:29:29PM -0700, david@lang.hm wrote:
>>     
>>> On Wed, 1 Apr 2009, Andreas T.Auer wrote:
>>>       
>>>> On 01.04.2009 22:15 david@lang.hm wrote:
>>>>         
>>>>> except if another file in the directory gets modified while it's
>>>>> writing out the first two, that file now would need to get written out
>>>>> as well, before the metadata for that directory can be written. if you
>>>>> have a busy system (say a database or log server), where files are
>>>>> getting modified pretty constantly, it can be a long time before all
>>>>> the file data is written out and the system is idle enough to write
>>>>> the metadata.
>>>>>           
>>>> Thank you, David, for this use case, but I think the problem could be
>>>> solved quite easily:
>>>>
>>>> At any write-out time, e.g. after collecting enough data for delayed
>>>> allocation or at fsync()
>>>>
>>>> 1) copy the metadata in memory, i.e. snapshot it
>>>> 2) write out the data corresponding to the metadata-snapshot
>>>> 3) write out the snapshot of the metadata
>>>>
>>>> In that way subsequent metadata changes should not interfere with the
>>>> metadata-update on disk.
>>>>         
>>> the problem with this approach is that the dcache has no provision for
>>> there being two (or more) copies of the disk block in it's cache, adding
>>> this would significantly complicate things (it was mentioned briefly a
>>> few days ago in this thread)
>>>       

I must have missed that message and can't find it.

>> It seems that it's obviously the "right way" to solve the problem
>> though.  How much does the dcache need to know about this "in flight"
>> block (ok, blocks - I can imagine a pathological case where there
>> were a stack of them all slightly different in the queue)?
>>     
>
> but if only one filesystem needs this caability is it really worth 
> complicating the dcache for the entire system?
>   

No, it's not necessary. It should be possible for the specific fs to
keep the metadata copy internally. And as long as these blocks are
written immediately after writing the data, there should be no "queue"
of copies, depending on how fsyncs are handled while the fs is
committing. There might be one copy for the current commit and (at most)
one copy corresponding to the most recent pending fsync. If there are
multiple fsyncs before the commit is finished, the "pending copy" could
simply be overwritten.

Andreas

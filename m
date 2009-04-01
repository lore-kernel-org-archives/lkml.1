Return-Path: <linux-kernel-owner+w=401wt.eu-S934513AbZDAVeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934513AbZDAVeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbZDAVd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:33:57 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:31909 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbZDAVd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:33:56 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNbYY5/NAUgO
X-RZG-CLASS-ID: mo05
Message-ID: <49D3DDBF.9060406@ursus.ath.cx>
Date: Wed, 01 Apr 2009 23:33:51 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: david@lang.hm
CC: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <gqr50k$4aq$1@ger.gmane.org> <alpine.DEB.1.10.0903311813390.28893@asgard.lang.hm> <49D3954A.9010309@tmr.com> <alpine.DEB.1.10.0904011311240.28893@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0904011311240.28893@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01.04.2009 22:15 david@lang.hm wrote:
> On Wed, 1 Apr 2009, Bill Davidsen wrote:
>
>> david@lang.hm wrote:
>>> it's not that it's deliberatly pushing metadata out ahead of file
>>> data, but say you have the following sequence
>>>
>>> write to file1
>>> update metadata for file1
>>> write to file2
>>> update metadata for file2
>>>
>>> if file1 and file2 are in the same directory your software can
>>> finish all four of these steps before _any_ of the data gets pushed
>>> to disk.
>>>
>>> then when the system goes to write the metadata for file1 it is
>>> pushing the then-current copy of that sector to disk, which includes
>>> the metadata for file2, even though the data for file2 hasn't been
>>> written yet.
>>>
>>> if you try to say 'flush all data blocks before metadata blocks' and
>>> have a lot of activity going on in a directory, and have to wait
>>> until it all stops before you write any of the metadata out, you
>>> could be blocked from writing the metadata for a _long_ time.
>>>
>> If you mean "write all data for that file" before the metadata, it
>> would seem to behave the way an fsync would, and the metadata should
>> go out in some reasonable time.
>
> except if another file in the directory gets modified while it's
> writing out the first two, that file now would need to get written out
> as well, before the metadata for that directory can be written. if you
> have a busy system (say a database or log server), where files are
> getting modified pretty constantly, it can be a long time before all
> the file data is written out and the system is idle enough to write
> the metadata.
Thank you, David, for this use case, but I think the problem could be
solved quite easily:

At any write-out time, e.g. after collecting enough data for delayed
allocation or at fsync()

1) copy the metadata in memory, i.e. snapshot it
2) write out the data corresponding to the metadata-snapshot
3) write out the snapshot of the metadata

In that way subsequent metadata changes should not interfere with the
metadata-update on disk.

Andreas

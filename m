Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbYBEQHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbYBEQHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbYBEQH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:07:26 -0500
Received: from mail.syneticon.net ([213.239.212.131]:45404 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbYBEQHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:07:24 -0500
Message-ID: <47A889AB.9090301@wpkg.org>
Date: Tue, 05 Feb 2008 17:07:07 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@HansenPartnership.com, bart.vanassche@gmail.com,
       vst@vlnb.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, scst-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stgt-devel@lists.berlios.de
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
References: <e2e108260801300029r1a949353k73b30f1f28db0bc9@mail.gmail.com>	<1201710175.3292.16.camel@localhost.localdomain>	<47A80CB9.9000805@wpkg.org> <20080205223740L.tomof@acm.org>
In-Reply-To: <20080205223740L.tomof@acm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori schrieb:
> On Tue, 05 Feb 2008 08:14:01 +0100
> Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> 
>> James Bottomley schrieb:
>>
>>> These are both features being independently worked on, are they not?
>>> Even if they weren't, the combination of the size of SCST in kernel plus
>>> the problem of having to find a migration path for the current STGT
>>> users still looks to me to involve the greater amount of work.
>> I don't want to be mean, but does anyone actually use STGT in
>> production? Seriously?
>>
>> In the latest development version of STGT, it's only possible to stop
>> the tgtd target daemon using KILL / 9 signal - which also means all
>> iSCSI initiator connections are corrupted when tgtd target daemon is
>> started again (kernel upgrade, target daemon upgrade, server reboot etc.).
> 
> I don't know what "iSCSI initiator connections are corrupted"
> mean. But if you reboot a server, how can an iSCSI target
> implementation keep iSCSI tcp connections?

The problem with tgtd is that you can't start it (configured) in an
"atomic" way.
Usually, one will start tgtd and it's configuration in a script (I 
replaced some parameters with "..." to make it shorter and more readable):


tgtd
tgtadm --op new ...
tgtadm --lld iscsi --op new ...


However, this won't work - tgtd goes immediately in the background as it 
is still starting, and the first tgtadm commands will fail:

# bash -x tgtd-start
+ tgtd
+ tgtadm --op new --mode target ...
tgtadm: can't connect to the tgt daemon, Connection refused
tgtadm: can't send the request to the tgt daemon, Transport endpoint is 
not connected
+ tgtadm --lld iscsi --op new --mode account ...
tgtadm: can't connect to the tgt daemon, Connection refused
tgtadm: can't send the request to the tgt daemon, Transport endpoint is 
not connected
+ tgtadm --lld iscsi --op bind --mode account --tid 1 ...
tgtadm: can't find the target
+ tgtadm --op new --mode logicalunit --tid 1 --lun 1 ...
tgtadm: can't find the target
+ tgtadm --op bind --mode target --tid 1 -I ALL
tgtadm: can't find the target
+ tgtadm --op new --mode target --tid 2 ...
+ tgtadm --op new --mode logicalunit --tid 2 --lun 1 ...
+ tgtadm --op bind --mode target --tid 2 -I ALL


OK, if tgtd takes longer to start, perhaps it's a good idea to sleep a 
second right after tgtd?

tgtd
sleep 1
tgtadm --op new ...
tgtadm --lld iscsi --op new ...


No, it is not a good idea - if tgtd listens on port 3260 *and* is 
unconfigured yet,  any reconnecting initiator will fail, like below:

end_request: I/O error, dev sdb, sector 7045192
Buffer I/O error on device sdb, logical block 880649
lost page write due to I/O error on sdb
Aborting journal on device sdb.
ext3_abort called.
EXT3-fs error (device sdb): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
end_request: I/O error, dev sdb, sector 7045880
Buffer I/O error on device sdb, logical block 880735
lost page write due to I/O error on sdb
end_request: I/O error, dev sdb, sector 6728
Buffer I/O error on device sdb, logical block 841
lost page write due to I/O error on sdb
end_request: I/O error, dev sdb, sector 7045192
Buffer I/O error on device sdb, logical block 880649
lost page write due to I/O error on sdb
end_request: I/O error, dev sdb, sector 7045880
Buffer I/O error on device sdb, logical block 880735
lost page write due to I/O error on sdb
__journal_remove_journal_head: freeing b_frozen_data
__journal_remove_journal_head: freeing b_frozen_data


Ouch.

So the only way to start/restart tgtd reliably is to do hacks which are 
needed with yet another iSCSI kernel implementation (IET): use iptables.

iptables <block iSCSI traffic>
tgtd
sleep 1
tgtadm --op new ...
tgtadm --lld iscsi --op new ...
iptables <unblock iSCSI traffic>


A bit ugly, isn't it?
Having to tinker with a firewall in order to start a daemon is by no 
means a sign of a well-tested and mature project.

That's why I asked how many people use stgt in a production environment 
- James was worried about a potential migration path for current users.



-- 
Tomasz Chmielewski
http://wpkg.org


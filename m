Return-Path: <linux-kernel-owner+w=401wt.eu-S933540AbZHEGlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540AbZHEGlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 02:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933520AbZHEGlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 02:41:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54669 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933485AbZHEGk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 02:40:56 -0400
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Sachin Sant <sachinp@in.ibm.com>, netdev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>, matthltc@us.ibm.com,
       lkml <linux-kernel@vger.kernel.org>
References: <20090626162418.GA24828@us.ibm.com>
	<20090724124614.6acc5054@nehalam>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 04 Aug 2009 23:40:47 -0700
In-Reply-To: <20090724124614.6acc5054@nehalam> (Stephen Hemminger's message of "Fri\, 24 Jul 2009 12\:46\:14 -0700")
Message-ID: <m1zlaeu5jk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: shemminger@vyatta.com, linux-kernel@vger.kernel.org, matthltc@us.ibm.com, davem@davemloft.net, netdev@vger.kernel.org, sachinp@in.ibm.com, containers@lists.osdl.org, serue@us.ibm.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Hemminger <shemminger@vyatta.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_05 8+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 1/1] veth: don't free priv->status until dev->destructor (v2)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@vyatta.com> writes:

> On Fri, 26 Jun 2009 11:24:18 -0500
> "Serge E. Hallyn" <serue@us.ibm.com> wrote:
>
>> Based on the commit msg on ae0e8e82205c903978a79ebf5e31c670b61fa5b4, it looks
>
>>  	ether_setup(dev);
>> @@ -306,7 +320,7 @@ static void veth_setup(struct net_device *dev)
>>  	dev->netdev_ops = &veth_netdev_ops;
>>  	dev->ethtool_ops = &veth_ethtool_ops;
>>  	dev->features |= NETIF_F_LLTX;
>> -	dev->destructor = free_netdev;
>> +	dev->destructor = veth_dev_free;
>>
>
> This is still going to oops if sysfs statistics referenced
> after module unload because module is unloaded (code is gone)
> and veth_dev_free no longer exists.

Has anyone actually seen that cause an oops?

The reason I am asking is that as I read the code we cannot have
this problem.  At worst the destructor callback is delayed until:

veth_exit
  rtnl_link_unregister
    rtnl_unlock
      netdev_run_todo
        dev->destructor


Similarly even if the sysfs filehandle is open we have called:

netdev_unregister_kobject
  ...
    sysfs_addrm_finish
      sysfs_deactivate

Which guarantees that sysfs_get_active_two will fail and all
subsequent actions on that file will fail.

Eric

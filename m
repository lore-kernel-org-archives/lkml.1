Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYLDXxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYLDXxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 18:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYLDXxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 18:53:45 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:25956 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYLDXxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 18:53:44 -0500
Message-ID: <49386D75.2030302@oracle.com>
Date: Thu, 04 Dec 2008 15:53:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [W1] Updated documentation.
References: <12284022104086-git-send-email-zbr@ioremap.net> <122840221468-git-send-email-zbr@ioremap.net> <12284022143564-git-send-email-zbr@ioremap.net> <12284022144105-git-send-email-zbr@ioremap.net> <12284022141659-git-send-email-zbr@ioremap.net>
In-Reply-To: <12284022141659-git-send-email-zbr@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49386D78.029C:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

Evgeniy Polyakov wrote:
> Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
> ---
>  Documentation/w1/w1.netlink |   34 +++++++++++++++++++++++++---------
>  1 files changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/w1/w1.netlink b/Documentation/w1/w1.netlink
> index 3640c7c..eae5c8b 100644
> --- a/Documentation/w1/w1.netlink
> +++ b/Documentation/w1/w1.netlink
> @@ -17,25 +17,27 @@ Protocol.
>  [struct cn_msg] - connector header. It's length field is equal to size of the attached data.

(not in this patch, but:)              Its


>  [struct w1_netlink_msg] - w1 netlink header.
>  	__u8 type 	- message type.
> +			W1_LIST_MASTERS - list current bus master list
>  			W1_SLAVE_ADD/W1_SLAVE_REMOVE - slave add/remove events.
>  			W1_MASTER_ADD/W1_MASTER_REMOVE - master add/remove events.
>  			W1_MASTER_CMD - userspace command for bus master device (search/alarm search).
>  			W1_SLAVE_CMD - userspace command for slave device (read/write/ search/alarm search
>  					for bus master device where given slave device found).
>  	__u8 res	- reserved
> -	__u16 len	- size of attached to this header data.
> +	__u16 len	- size of data attached to this header data.
>  	union {
> -		__u8 id;			 - slave unique device id
> +		__u8 id[8];			 - slave unique device id
>  		struct w1_mst {
>  			__u32		id;	 - master's id.
>  			__u32		res;	 - reserved
>  		} mst;
>  	} id;
>  
> -[strucrt w1_netlink_cmd] - command for gived master or slave device.
> +[struct w1_netlink_cmd] - command for given master or slave device.
>  	__u8 cmd	- command opcode.
>  			W1_CMD_READ 	- read command.
>  			W1_CMD_WRITE	- write command.
> +			W1_CMD_TOUCH	- touch command (write and sample data back to userspace).
>  			W1_CMD_SEARCH	- search command.
>  			W1_CMD_ALARM_SEARCH - alarm search command.
>  	__u8 res	- reserved
> @@ -44,7 +46,7 @@ Protocol.
>  	__u8 data[0]	- data for this command.
>  
>  
> -Each connector message can include one or more w1_netlink_msg with zero of more attached w1_netlink_cmd messages.
> +Each connector message can include one or more w1_netlink_msg with zero or more attached w1_netlink_cmd messages.

Please limit lines to a maximum of 80 characters.  Around 72 would be Good.
(here and elsewhere)

>  For event messages there are no w1_netlink_cmd embedded structures, only connector header
>  and w1_netlink_msg strucutre with "len" field being zero and filled type (one of event types)

                      structure

> @@ -59,11 +61,25 @@ cn_msg.len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd) + cmd
>  w1_netlink_msg.len = sizeof(struct w1_netlink_cmd) + cmd->len;
>  w1_netlink_cmd.len = cmd->len;
>  
> +Replies to W1_LIST_MASTERS should send a message back to the userspace
> +which will contain list of all registered master ids in the following
> +format:
> +	
> +	cn_msg (CN_W1_IDX.CN_W1_VAL as id, len is equal to sizeof(struct
> +	w1_netlink_msg) plus number of masters multipled by 4)

	                                       multiplied

> +	w1_netlink_msg (type: W1_LIST_MASTERS, len is equal to number of masters
> +	multiplied by 4 (u32 size))
> +	id0 ... idN
> +	
> +	Each message is at most 4k in size, so if number of master devices
> +	exceeds this, it will be split into several messages, cn.seq will be
> +	increased for each one.
> +	
>  
>  Operation steps in w1 core when new command is received.
>  =======================================================
>  
> -When new message (w1_netlink_msg) is received w1 core detects if it is master of slave request,
> +When new message (w1_netlink_msg) is received w1 core detects if it is master or slave request,
>  according to w1_netlink_msg.type field.
>  Then master or slave device is searched for.
>  When found, master device (requested or those one on where slave device is found) is locked.
> @@ -82,10 +98,10 @@ Connector [1] specific documentation.
>  Each connector message includes two u32 fields as "address".
>  w1 uses CN_W1_IDX and CN_W1_VAL defined in include/linux/connector.h header.

      uses them for what?

>  Each message also includes sequence and acknowledge numbers.
> -Sequence number for event messages is appropriate bus master sequence number increased with
> +Sequence number for event messages is appropriate bus master sequence number increased with 

Line ends with space.  Please check for that throughout the file.

>  each event message sent "through" this master.
>  Sequence number for userspace requests is set by userspace application.
> -Sequence number for reply is the same as was in request, and
> +Sequence number for reply is the same as was in request, and 
>  acknowledge number is set to seq+1.
>  
>  
> @@ -93,6 +109,6 @@ Additional documantion, source code examples.

                                documentation

>  ============================================
>  
>  1. Documentation/connector
> -2. http://tservice.net.ru/~s0mbre/archive/w1
> -This archive includes userspace application w1d.c which
> +2. http://www.ioremap.net/archive/w1
> +This archive includes userspace application w1d.c which 
>  uses read/write/search commands for all master/slave devices found on the bus.

I'll plan to review the entire doc file.

Thanks,
~Randy

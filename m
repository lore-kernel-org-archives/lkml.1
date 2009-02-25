Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbZBYGsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbZBYGsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 01:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZBYGry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 01:47:54 -0500
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:35089 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbZBYGrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 01:47:53 -0500
Message-ID: <49A4E995.50801@numericable.fr>
Date: Wed, 25 Feb 2009 07:47:49 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>
CC: Casey Schaufler <casey@schaufler-ca.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH][SMACK] add a socket_post_accept hook to fix netlabel
 issues with labeled TCP servers V1
References: <fa.eUdEnVYPYgnfwD9aw1dVY6gL1+E@ifi.uio.no> <200902241738.08877.paul.moore@hp.com> <49A47BEF.5030507@numericable.fr> <200902241836.59679.paul.moore@hp.com>
In-Reply-To: <200902241836.59679.paul.moore@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore wrote:
> On Tuesday 24 February 2009 05:59:59 pm etienne wrote:
>> Paul Moore wrote:
>>> On Tuesday 24 February 2009 05:20:42 pm etienne wrote:
>>>> Paul Moore wrote:
>>>>> On Tuesday 24 February 2009 04:28:24 pm etienne wrote:
>>>>>>  /**
>>>>>> + * smack_socket_post_access - post access check
>>>>>> + * @sock: the socket
>>>>>> + * @newsock : the grafted sock
>>>>>> + *
>>>>>> + * we have to match client IP against smack_host_label()
>>>>>> + */
>>>>>> +static void  smack_socket_post_accept(struct socket *sock, struct
>>>>>> socket *newsock) +{
>>>>>> +	char *hostsp;
>>>>>> +	struct sockaddr_storage address;
>>>>>> +	struct sockaddr_in *sin;
>>>>>> +	struct sockaddr_in6 *sin6;
>>>>>> +	struct in6_addr *addr6;
>>>>>> +	struct socket_smack *ssp = newsock->sk->sk_security;
>>>>>> +	int len;
>>>>>> +
>>>>>> +	if (sock->sk == NULL)
>>>>>> +		return;
>>>>>> +
>>>>>> +	/* sockets can listen on both IPv4 & IPv6,
>>>>>> +	   and fallback to V4 if client is V4 */
>>>>>> +	if  (newsock->sk->sk_family != AF_INET && newsock->sk->sk_family !=
>>>>>> AF_INET6) +		return;
>>>>>> +
>>>>>> +	/* get the client IP address **/
>>>>>> +	newsock->ops->getname(newsock, (struct sockaddr *)&address, &len,
>>>>>> 2); +
>>>>>> +	switch (newsock->sk->sk_family) {
>>>>>> +	case AF_INET:
>>>>>> +		sin = (struct sockaddr_in *)&address;
>>>>>> +		break;
>>>>>> +	case AF_INET6:
>>>>>> +		sin6  = (struct sockaddr_in6 *)&address;
>>>>>> +		addr6 = &sin6->sin6_addr;
>>>>>> +		/* if a V4 client connects to a V6 listening server,
>>>>>> +		 * we will get a IPV6_ADDR_MAPPED mapped address here
>>>>>> +		 * we have to handle this case too
>>>>>> +		 * the test below is ipv6_addr_type()== IPV6_ADDR_MAPPED
>>>>>> +		 * without the requirement to have IPv6 compiled in
>>>>>> +		 */
>>>>>> +		if ((addr6->s6_addr32[0] | addr6->s6_addr32[1]) == 0 &&
>>>>>> +				addr6->s6_addr32[2] == htonl(0x0000ffff)) {
>>>>>> +			__be32 addr = sin6->sin6_addr.s6_addr32[3];
>>>>>> +			__be16 port = sin6->sin6_port;
>>>>>> +			sin = (struct sockaddr_in *)&address;
>>>>>> +			sin->sin_family = AF_INET;
>>>>>> +			sin->sin_port = port;
>>>>>> +			sin->sin_addr.s_addr = addr;
>>>>>> +		} else {
>>>>>> +			/* standard IPv6, we'll send unlabeled */
>>>>>> +			smack_netlabel(newsock->sk, SMACK_UNLABELED_SOCKET);
>>>>>> +			return;
>>>>>> +		}
>>>>>> +		break;
>>>>>> +	default:
>>>>>> +		/** not possible to be there **/
>>>>>> +		return;
>>>>>> +	}
>>>>>> +	/* so, is there a label for the source IP **/
>>>>>> +	hostsp = smack_host_label(sin);
>>>>>> +
>>>>>> +	if (hostsp == NULL) {
>>>>>> +		if (ssp->smk_labeled != SMACK_CIPSO_SOCKET)
>>>>>> +			smack_netlabel(newsock->sk, SMACK_CIPSO_SOCKET);
>>>>>> +		return;
>>>>>> +	}
>>>>>> +	if (ssp->smk_labeled != SMACK_UNLABELED_SOCKET)
>>>>>> +		smack_netlabel(newsock->sk, SMACK_UNLABELED_SOCKET);
>>>>>> +	return;
>>>>>> +}
>>>>> NAK, you can't ignore return values like that.
>>>>>
>>>>> I'm sorry I didn't get a chance to respond to your email from this
>>>>> morning, but the problem with the post_accept() hook is that you can't
>>>>> fail in this hook.  There has been a _lot_ of discussion about this
>>>>> over the past couple of years on the LSM list.  You should check the
>>>>> archives for all the details but the main problem is that the
>>>>> post_accept() hook is too late to deny the incoming connection so you
>>>>> can't reject the connection at that point in any sane manner.
>>>> well, i don't want to reject the connection here :)
>>>>
>>>>> I think I'm going to draft a patch to remove the post_accept()
>>>>> hook since no one in-tree is using it and it's existence seems to cause
>>>>> more problems than it solves.
>>>>>
>>>>> Now, I understand that your patch doesn't actually enforce any access
>>>>> controls but it does call smack_netlabel() in several places and that
>>>>> function can fail
>>>> The smack_netlabel(newsock->sk, SMACK_CIPSO_SOCKET) can failed, but has
>>>> no interest in this function (because the socket has already be
>>>> SMACK_CIPSO_SOCKET labeled by the policy) I can remove it.
>>>>
>>>> but smack_netlabel(SMACK_UNLABELED_SOCKET) cannot fail, and that's what
>>>> i'm interested in could this make the patch acceptable?
>>> Please elaborate a bit more on how you would intend a user to configure
>>> and make use of this.  Also, in what cases would you remove the NetLabel
>>> from a socket?  What cases would you keep it?
>> well, i think it is simple : let's say i want to run a "smack-labelled
>> server" (apache, vsftpd, ...) clients connect from internet,  so the server
>> admin/user  will want to add a "0.0.0.0/0 @" entry in netlabel that will
>> _fail_ because the server will send back "labeled" packets.
> 
> I had to go back and look at the address based labeling patches, I had somehow 
> forgotten that the single label support in Smack can only be used for removing 
> labels, not adding them.  With that in mind your approach should work although 
> you will still get really bizarre behavior in the following case:
> 
>  * Service not running at the ambient label
>  * Only address based label loaded into Smack is "0.0.0.0/0 @" (everything
>    unlabeled)
>  * Client connects to service using labeled networking
> 
yes i agree. I think, as Casey mentionned, that we should improve the /smack/netlabel
semantics to have "@IP/MASK CISPO"
and have smack_host_label return NULL in that case. 

In practice label based clients IP should be known by the sysadmin (it's your corporate network). 
The information we should inject to smack is where the clients using labeled networking are, because I expect they
 are fewer than the unlabeled one 

I personnaly haven't seen a deployement so far (and working for  a french ISP, i've seen quite a lot of customer corporate networks, arguably not the most secured).
But maybe it has been more deployed in US?

regards
Etienne

> If you and Casey can live with labeled connection suddenly becoming unlabeled 
> (I doubt the remote host will deal with it very gracefully) then go for it.
> 
what bothered me the most with current code is that we had different behaviors for tcp and udp 
(which are very different beasts, ok, but should get the same smack/CIPSO treatment because _smack user interface
deals with layer3 information not layer4_). 

The _most important_ thing, whatever decision we make, is to DOCUMENT the behavior. You know, 10 days before i was 
"only a user",  i had to dig into the code precisely because i didn't understand well the few docs.
(but it was _a lot_ of fun ;) )

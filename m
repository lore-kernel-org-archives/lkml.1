Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbZLKTkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbZLKTkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 14:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761766AbZLKTkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 14:40:11 -0500
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:50928
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761133AbZLKTkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 14:40:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As4BACUvIkt8qT8O/2dsb2JhbAAImGO9OoI7gXAEgnuCag
X-IronPort-AV: E=Sophos;i="4.47,384,1257091200"; 
   d="scan'208";a="609415857"
Message-ID: <4B22A00A.6030308@ii.net>
Date: Sat, 12 Dec 2009 03:39:54 +0800
From: Cliffe <cliffe@ii.net>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Lincoln Yeoh <lyeoh@pop.jaring.my>
CC: apparmor-dev@forge.novell.com, selinux@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       fbac-lsm-general@lists.sourceforge.net
Subject: Re: [Apparmor-dev] New security system FBAC-LSM announcement  and
 call for collaborators
References: <4B22032F.906@ii.net> <200912111823.nBBINTDe064090@vsmtp6.jaring.my>
In-Reply-To: <200912111823.nBBINTDe064090@vsmtp6.jaring.my>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lincoln Yeoh wrote:
> At 04:30 PM 12/11/2009, Cliffe wrote:
>
>> I developed FBAC-LSM for my PhD research. FBAC-LSM restricts programs 
>> based on the features each application provides. Reusable policy 
>> abstractions, known as functionalities, can be used to grant the 
>> authority to perform high level features (for example using the 
>> Web_Browser functionality) or lower level features (such as using the 
>> HTTP_Client functionality) or to grant privileges to access any 
>> specified resources. Functionalities are parameterised, which allows 
>> them to be adapted to the needs of specific applications. 
>> Functionalities are also hierarchical; that is, functionalities can 
>> contain other functionalities.
>
> Looks good!
>
> Been trying to get distros to implement something like this too, glad 
> there's some progress :).
>
> https://bugzilla.novell.com/show_bug.cgi?id=308760#c1
>
> https://bugs.launchpad.net/ubuntu/+bug/156693
>
> I think the slight difference is, with my proposal a program might 
> actually request the "functionality" (I called it "sandbox template") 
> it wants to be run with. This is not as crazy as it seems, since it 
> means the program declares its limits upfront before the user or the 
> OS says "that looks OK".
>
> And these sandboxes (functionalities and custom functionalities) can 
> be digitally signed (along with the programs).
>
> Thus, a distro might sign sandboxes for certain apps - this way a 
> desktop user will not need to be bothered or prompted for those apps.

This can be divided into a few separate ideas.

-FBAC-LSM can currently have multiple policies which apply 
simultaneously. Sets of policies are called “confinements” and each 
confinement can apply to a list of users, a separate list says which 
users are authorised to maintain (configure) each confinement. One 
possible scenario would be to have one confinement which has all the 
developer-specified policies. This is not enough security on its own 
though, because the security goals of developers is different to that of 
users and administrators. Developers may only care about software 
vulnerabilities, and would be inclined to specify rather liberal rules.

Then the user or administrator can use also other confinements to 
enforce their own goals. An administrator may want to ensure that the 
user can only use the program to edit files in their own home directory. 
The user may only want the web browser to download files to particular 
directories (within their home directory) to protect the user’s 
resources from the web browser (a security goal which the developer 
would not care about).

The end result is that each “stakeholder” can enforce their own security 
goals. If a user is happy enough with the policies created by third 
parties, then they can benefit without doing anything.

It is currently possible for the system admin to configure a confinement 
to require a policy to be present for every application in a particular 
confinement, otherwise the process wont start.

-I started developing a signature-based application identification 
approach, although that idea got put far back on the back burner. 
FBAC-LSM currently identifies applications by their pathnames. I think 
there may be benefits of using signatures, to further confine versions 
of programs, but a fallback pathname based approach ensures that the 
program can run and is confined. It could be handy to also allow 
programs with certain signatures to be terminated. This is an area for 
further development.

-Most of the code is in place for functionalities to be dropped 
dynamically for processes. This could allow processes to say “I only 
need functionalities x, y and z, drop the rest". This feature is 
currently incomplete.

>
> A paranoid administrator can prevent the execution of programs that do 
> not have acceptable sandboxes (only programs with very safe sandboxes 
> and programs with "not so safe" sandboxes but are signed).

This is currently possible.

>
> Also, a trusted 3rd party (security auditor etc) could audit a program 
> and its sandbox, and if it looks ok, certify/sign it. Or maybe only 
> certify it with a modified sandbox.

This is a very interesting idea which should be investigated further. 
Ways for community members and trusted third parties to share and review 
policies is definitely an area for future research.

>
> It should be easier to verify that a proposed sandbox is OK, than it 
> is to verify that a program will be OK to run before running it (which 
> is like solving a halting problem without the source code and full 
> knowledge of the inputs ;) ).

Yeah, FBAC-LSM does a pretty good job of creating a working policy 
without first running the program. This makes it possible to say "this 
is a game" (in fact FBAC-LSM Policy Manager will say "this looks like a 
game"), FBAC-LSM Policy Manager then does some analysis and discovers 
the application specific details, and asks the user where the game 
stores saved games.

So a policy has been created without running the program. So if the 
program is malicious the user is protected. In most cases the user 
shouldn't have to use the learning mode, although it is available if it 
is needed.

>
> The problem is we'd have to prevent the wrong programs from being run 
> with the wrong custom sandboxes - the signature should take care of it 
> - change the app and the signature + template + app should no longer 
> be valid. However the problem is if the application is 
> updated/patched, the signature won't be valid, but this might be a 
> necessary tradeoff for custom sandboxes (or "full privilege" sandboxes).

Yeah. Signatures could differentiate between different versions of the 
same program. In most cases it would be safest to have a policy which 
applies to a program regardless of the version.


It sounds like you have some good ideas. Please consider contributing to 
the project. The signature approach, dynamic policy control, and policy 
sharing and reviewing are all ideas which can be developed further. Also 
more functionalities need to be developed (I will publish the 
methodology used). Alternatively please check out the TODO file to see 
if anything there looks like something you would like to do! 
(http://fbac-lsm.git.sourceforge.net/git/gitweb.cgi?p=fbac-lsm/fbac-lsm;a=blob;f=TODO)

Thanks for your interest in the project and your thoughts. Please 
subscribe to the fbac-lsm mailing list 
(https://lists.sourceforge.net/lists/listinfo/fbac-lsm-general)


Cheers,

Z. Cliffe Schreuders


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbZHLMXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbZHLMXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZHLMXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:23:31 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:38559 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbZHLMXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:23:30 -0400
From: Nicolas Palix <npalix@diku.dk>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>, Joe Perches <joe@perches.com>
Subject: Re: Typedef removal tool
Date: Wed, 12 Aug 2009 14:23:05 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
Cc: Julia Lawall <julia@diku.dk>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
References: <43e72e890908111418m47910085k2d0016e2add8914f@mail.gmail.com> <Pine.LNX.4.64.0908120659001.32131@ask.diku.dk> <43e72e890908120045s6e94bd5es480bb4ef1a66597c@mail.gmail.com>
In-Reply-To: <43e72e890908120045s6e94bd5es480bb4ef1a66597c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_qQrgK+XW85QEJRh"
Message-Id: <200908121423.06403.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_qQrgK+XW85QEJRh
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 12 August 2009 09:45:35 Luis R. Rodriguez wrote:
> On Tue, Aug 11, 2009 at 10:01 PM, Julia Lawall<julia@diku.dk> wrote:
> > On Tue, 11 Aug 2009, Luis R. Rodriguez wrote:
> >
> >> Anyone know if there is a typedef removal tool? When porting drivers
> >> this needs to be done quite often.
> >>
> >> FWIW I've started porting some driver and have come across some tools,
> >> or written my own scripts, which have helped. Using spatch to port a
> >> driver was such a tool I explored. I think I'll try to put together
> >> some info on the driver project wiki for this. typdef removal tool
> >> would still be neat.
> >
> > Nicolas Palix (in CC) did a bit of work on this recently using Coccinelle,
> > but the problem is that simply removing the typedef is not enough, one has
> > to come up with a name that is within the spirit of the names used in
> > Linux, or perhaps recognize that the structure in question already exists
> > in a more general form in the kernel an thus the declaration should be
> > removed completely.
> >
> > Someone else made a dedicated tool using a dictionary of the old and new
> > names that at least partially addresses these problems.  Nicolas knows who
> > that person is.
> 
> Sounds like a very proper way to do this.
> 
> I wrote something not-so-proper and simple based on Joe's work that
> just replaces a specified typedef name with one the user specifies.
> Should do it for simple porting where you do not have to prove
> correctness and avoid namespace collisions.
> 

We have done this for the new Hyper-V drivers.
Joe Perches (CC) proposes a shell and perl solution (cvt_typedef_to_struct.bash)
with the typedefs file dictionary, attached to this email.

I have modified my typedef_str.cocci file to use his dictionary.
This cocci file generates a cocci file per typedef to remove.
The generated files could be applied with the modified version
of Joe's shell script or by hand, at your convenience.

>   Luis
> 


-- 
Nicolas Palix

--Boundary-00=_qQrgK+XW85QEJRh
Content-Type: application/x-shellscript;
  name="cvt_typedef_to_struct.bash"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cvt_typedef_to_struct.bash"

#!/bin/bash
#
for line in $(cat typedefs) ; do
    from=$(echo $line | cut -f1 -d:)
    to=$(echo $line | cut -f2 -d:)
    echo "Converting typedef $from to struct $to"

    grep -rP --include=*.[ch] -l $from * | while read file ; do
	sed -r -i -e "s/\b$from\b/struct $to/g" $file
	sed -r -i -e "s/\bP$from\b/struct $to \*/g" $file
	sed -r -i -e "s/struct $to\s*\*\s*\b/struct $to \*/g" $file
	sed -r -i -e "s/\(struct $to\s*\*\)\s*/\(struct $to \*\)/g" $file
    done

    perl -i -e "local $/; while(<>) { s/\btypedef\s+struct\s+_$from\s*\{([\d\D]+?)\}\s*struct\s+$to\b[^;]*;/struct $to \{\1\};/g; print; }" \
	$(grep -rP -l --include=*.[ch] "\bstruct\s+$to\b" *)

    if [ "$1" == "compile" ] ; then
	cd ../../..
	make drivers/staging/hv/
	echo -n "Press return to commit: "
	read
	cd drivers/staging/hv
    fi
    git commit -s -m "staging/hv: convert typedef $from to struct $to" ../hv

done

--Boundary-00=_qQrgK+XW85QEJRh
Content-Type: application/x-shellscript;
  name="cvt_typedef_to_struct_with_cocci.bash"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cvt_typedef_to_struct_with_cocci.bash"

#!/bin/bash
#

export BASE=~/Documents/build/linux
export HV=$BASE/drivers/staging/hv

for line in $(cat typedefs) ; do
    from=$(echo $line | cut -f1 -d:)
    to=$(echo $line | cut -f2 -d:)
    echo "Converting typedef $from to struct $to"

    spatch.opt -inplace -include_headers -sp_file gen/$from.cocci -dir $HV -patch $BASE > gen/$from.patch
    find $HV -name "*.cocci_orig" -delete

    if [ "$1" == "compile" ] ; then
	make -C $BASE
	echo -n "Press return to commit: "
	read
    fi
    cd $BASE
    git commit -s -a -m "Staging: hv: Convert typedef $from to struct $to"
    cd -

done

--Boundary-00=_qQrgK+XW85QEJRh
Content-Type: text/plain;
  charset="UTF-8";
  name="typedefs"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="typedefs"

DEVICE_INFO:vmbus_device_info
GPA_RANGE:vmbus_gpa_range
HV_CONNECTION_INFO:hv_connection_info
HV_INPUT_POST_MESSAGE:hv_input_post_message
HV_INPUT_SIGNAL_EVENT:hv_input_signal_event
HV_MESSAGE:hv_message
HV_MESSAGE_HEADER:hv_message_header
HV_MESSAGE_PAGE:hv_message_page
HV_MONITOR_PAGE:hv_monitor_page
HV_MONITOR_PARAMETER:hv_monitor_parameter
HV_PORT_INFO:hv_port_info
HV_SYNIC_EVENT_FLAGS_PAGE:hv_synic_event_flags_page
HV_TIMER_MESSAGE_PAYLOAD:hv_timer_message_payload
MULTIPAGE_BUFFER:vmbus_multipage_buffer
NETVSC_DEVICE_INFO:netvsc_device_info
NETVSC_DRIVER_OBJECT:netvsc_driver_object
NVSP_1_MESSAGE_REVOKE_RECEIVE_BUFFER:nvsp_1_message_revoke_receive_buffer
NVSP_1_MESSAGE_REVOKE_SEND_BUFFER:nvsp_1_message_revoke_send_buffer
NVSP_1_MESSAGE_SEND_NDIS_VERSION:nvsp_1_message_send_ndis_version
NVSP_1_MESSAGE_SEND_RECEIVE_BUFFER:nvsp_1_message_send_receive_buffer
NVSP_1_MESSAGE_SEND_RECEIVE_BUFFER_COMPLETE:nvsp_1_message_send_receive_buffer_complete
NVSP_1_MESSAGE_SEND_RNDIS_PACKET:nvsp_1_message_send_rndis_packet
NVSP_1_MESSAGE_SEND_RNDIS_PACKET_COMPLETE:nvsp_1_message_send_rndis_packet_complete
NVSP_1_MESSAGE_SEND_SEND_BUFFER:nvsp_1_message_send_send_buffer
NVSP_1_MESSAGE_SEND_SEND_BUFFER_COMPLETE:nvsp_1_message_send_send_buffer_complete
NVSP_1_RECEIVE_BUFFER_SECTION:nvsp_1_receive_buffer_section
NVSP_MESSAGE:nvsp_message
NVSP_MESSAGE_HEADER:nvsp_message_header
NVSP_MESSAGE_INIT:nvsp_message_init
NVSP_MESSAGE_INIT_COMPLETE:nvsp_message_init_complete
PAGE_BUFFER:vmbus_page_buffer
PORT_INFO:vmbus_port_info
RCONDIS_CALL_MANAGER_PARAMETERS:rcondis_call_manager_parameters
RCONDIS_INDICATE_STATUS:rcondis_indicate_status
RCONDIS_MEDIA_PARAMETERS:rcondis_media_parameters
RCONDIS_MP_ACTIVATE_VC_COMPLETE:rcondis_mp_activate_vc_complete
RCONDIS_MP_ACTIVATE_VC_REQUEST:rcondis_mp_activate_vc_request
RCONDIS_MP_CREATE_VC:rcondis_mp_create_vc
RCONDIS_MP_CREATE_VC_COMPLETE:rcondis_mp_create_vc_complete
RCONDIS_MP_DEACTIVATE_VC_COMPLETE:rcondis_mp_deactivate_vc_complete
RCONDIS_MP_DEACTIVATE_VC_REQUEST:rcondis_mp_deactivate_vc_request
RCONDIS_MP_DELETE_VC:rcondis_mp_delete_vc
RCONDIS_MP_DELETE_VC_COMPLETE:rcondis_mp_delete_vc_complete
RCONDIS_MP_QUERY_REQUEST:rcondis_mp_query_request
RCONDIS_MP_SET_REQUEST:rcondis_mp_set_request
RCONDIS_SPECIFIC_PARAMETERS:rcondis_specific_parameters
RING_BUFFER_DEBUG_INFO:hv_ring_buffer_debug_info
RING_BUFFER_INFO:hv_ring_buffer_info
RNDIS_CO_ADDRESS_FAMILY:rndis_co_address_family
RNDIS_CONFIG_PARAMETER_INFO:rndis_config_parameter_info
RNDIS_DEVICE:rndis_device
RNDIS_DIAGNOSTIC_INFO:rndis_diagnostic_info
RNDIS_FILTER_DRIVER_OBJECT:rndis_filter_driver_object
RNDIS_FILTER_PACKET:rndis_filter_packet
RNDIS_FLOWSPEC:rndis_flowspec
RNDIS_HALT_REQUEST:rndis_halt_request
RNDIS_INDICATE_STATUS:rndis_indicate_status
RNDIS_INITIALIZE_COMPLETE:rndis_initialize_complete
RNDIS_INITIALIZE_REQUEST:rndis_initialize_request
RNDIS_KEEPALIVE_COMPLETE:rndis_keepalive_complete
RNDIS_KEEPALIVE_REQUEST:rndis_keepalive_request
RNDIS_OOBD:rndis_oobd
RNDIS_PACKET:rndis_packet
RNDIS_PER_PACKET_INFO:rndis_per_packet_info
RNDIS_QUERY_COMPLETE:rndis_query_complete
RNDIS_QUERY_REQUEST:rndis_query_request
RNDIS_REQUEST:rndis_request
RNDIS_RESET_COMPLETE:rndis_reset_complete
RNDIS_RESET_REQUEST:rndis_reset_request
RNDIS_SET_COMPLETE:rndis_set_complete
RNDIS_SET_REQUEST:rndis_set_request
STORVSC_DEVICE:storvsc_device
STORVSC_DEVICE_INFO:storvsc_device_info
STORVSC_DRIVER_OBJECT:storvsc_driver_object
STORVSC_REQUEST_EXTENSION:storvsc_request_extension
VMBUS_CHANNEL:vmbus_channel
VMBUS_CHANNEL_CLOSE_CHANNEL:vmbus_channel_close_channel
VMBUS_CHANNEL_DEBUG_INFO:vmbus_channel_debug_info
VMBUS_CHANNEL_GPADL_BODY:vmbus_channel_gpadl_body
VMBUS_CHANNEL_GPADL_CREATED:vmbus_channel_gpadl_created
VMBUS_CHANNEL_GPADL_HEADER:vmbus_channel_gpadl_header
VMBUS_CHANNEL_GPADL_TEARDOWN:vmbus_channel_gpadl_teardown
VMBUS_CHANNEL_GPADL_TORNDOWN:vmbus_channel_gpadl_torndown
VMBUS_CHANNEL_INITIATE_CONTACT:vmbus_channel_initiate_contact
VMBUS_CHANNEL_INTERFACE:vmbus_channel_interface
VMBUS_CHANNEL_MESSAGE_HEADER:vmbus_channel_message_header
VMBUS_CHANNEL_MESSAGE_TABLE_ENTRY:vmbus_channel_message_table_entry
VMBUS_CHANNEL_MSGINFO:vmbus_channel_msginfo
VMBUS_CHANNEL_OFFER_CHANNEL:vmbus_channel_offer_channel
VMBUS_CHANNEL_OPEN_CHANNEL:vmbus_channel_open_channel
VMBUS_CHANNEL_OPEN_RESULT:vmbus_channel_open_result
VMBUS_CHANNEL_QUERY_VMBUS_VERSION:vmbus_channel_query_vmbus_version
VMBUS_CHANNEL_RELID_RELEASED:vmbus_channel_relid_released
VMBUS_CHANNEL_RESCIND_OFFER:vmbus_channel_rescind_offer
VMBUS_CHANNEL_VERSION_RESPONSE:vmbus_channel_version_response
VMBUS_CHANNEL_VERSION_SUPPORTED:vmbus_channel_version_supported
VMBUS_CHANNEL_VIEW_RANGE_ADD:vmbus_channel_view_range_add
VMBUS_CHANNEL_VIEW_RANGE_REMOVE:vmbus_channel_view_range_remove
VMBUS_DRIVER_OBJECT:vmbus_driver_object
VSTOR_PACKET:vstor_packet
XFERPAGE_PACKET:netvsc_xferpage_packet

--Boundary-00=_qQrgK+XW85QEJRh
Content-Type: text/x-csrc;
  charset="UTF-8";
  name="typedef_str.cocci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="typedef_str.cocci"

//
// Generate cocci file with
//
//BASE=~/linux
//NEXT=~/linux/drivers/staging/hv
//spatch.opt -include_headers -sp_file typedef_str -dir $(NEXT) -patch $(BASE)
//
// Applying a generated cocci file
//
//.cocci.patch:
//	spatch.opt -inplace -include_headers -sp_file $< -dir $(NEXT) -patch $(BASE) > $@

@initialize:python@

f = open("typedefs", 'r')
d = dict()

for line in f:
    (key, sep, name) = line.partition(':')
    d[key] = name

f.close()

@r@
identifier st;
type typ;
@@

typedef struct st {
...
} typ ;

@script: python@
st << r.st;
typ << r.typ;
@@

name = "gen/%s.cocci" % typ
strname = d[typ]

print name
f = open(name, 'w')

f.write( "@rm_%s@\n"            % typ    )
f.write( "@@\n"                          )
f.write( "-typedef struct %s\n" % st	 )
f.write( "+struct %s\n"         % strname)
f.write( "{...}\n"		         )
f.write( "-%s\n"                % typ	 )
f.write( ";\n\n"	        	 )

f.write( "@fixtypedef_%s@\n"    % typ    )
f.write( "typedef %s;\n"        % typ	 )
f.write( "@@\n"                          )
f.write( "-%s\n"                % typ	 )
f.write( "+struct %s\n\n"       % strname)

f.write( "@fixstruct_%s@\n"     % st     )
f.write( "@@\n"                          )
f.write( "struct\n"                 	 )
f.write( "-%s\n"                % st	 )
f.write( "+%s\n"                % strname)

f.close()

--Boundary-00=_qQrgK+XW85QEJRh--
